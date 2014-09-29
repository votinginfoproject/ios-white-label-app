//
//  UserElection+API.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 1/31/14.
//  
//

#import "UserElection+API.h"
#import "AppSettings.h"

@implementation UserElection (API)


+ (UserElection*) getUnique:(NSString*)electionId
        withUserAddress:(UserAddress*)userAddress
{
    UserElection *userElection = nil;
    if (electionId && [electionId length] > 0 && [userAddress hasAddress]) {
        // Ensure an Election object is created when a UserElection one is requested
        Election *election = [Election getUnique:electionId];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"electionId == %@ && userAddress == %@", electionId, userAddress];
        userElection = [UserElection MR_findFirstWithPredicate:predicate];
        if (!userElection) {
            userElection = [UserElection MR_createEntity];
            userElection.userAddress = userAddress;
#if DEBUG
            NSLog(@"Created new userElection with id: %@", electionId);
#endif
        } else {
#if DEBUG
            NSLog(@"Retrieved userElection %@ from data store", electionId);
#endif
        }
        [userElection setWithElection:election];
        NSManagedObjectContext *moc = [NSManagedObjectContext MR_defaultContext];
        [moc MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError* error) {
            if (success) {
                NSLog(@"UserElection SAVED: %@, %@", electionId, userAddress.address);
            } else if (error) {
                NSLog(@"UserElection ERROR: while saving: %@", error);
            } else {
                NSLog(@"UserElection: no change");
            }
        }];
    }
    return userElection;
}

- (void)setWithElection:(Election*)election {
        self.electionId = election.electionId;
        self.electionName = election.electionName;
        self.date = election.date;
}

- (NSArray*)getUniqueParties
{
    NSMutableDictionary *parties = [NSMutableDictionary dictionary];
    for (Contest *contest in self.contests) {
        NSString *party = contest.primaryParty;
        if (party) {
            parties[party] = party;
        }
    }
    // Sort alphabetically to avoid appearing partisan by certain parties appearing first
    return [[parties allValues] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
}

- (NSArray*)filterPollingLocations:(VIPPollingLocationType)type
{
    NSArray *locations = [self getSorted:@"pollingLocations"
                              byProperty:@"isEarlyVoteSite"
                               ascending:NO];
    NSArray *filteredLocations = locations;
    if (type == VIPPollingLocationTypeEarlyVote) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isEarlyVoteSite == YES"];
        filteredLocations = [locations filteredArrayUsingPredicate:predicate];
    } else if (type == VIPPollingLocationTypeNormal) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isEarlyVoteSite == NO"];
        filteredLocations = [locations filteredArrayUsingPredicate:predicate];

    }
    return filteredLocations;
}

// For now always yes to test delete/update on CoreData
- (BOOL) shouldUpdate
{
    // Update if no last updated date
    if (!self.lastUpdated) {
        return YES;
    }
    // Update if all of these are empty
    if ([self.pollingLocations count] == 0 && [self.contests count] == 0 && [self.states count] == 0) {
        return YES;
    }
    // Update if election data is more than x days old
    int days = [[[AppSettings settings] valueForKey:@"VotingInfoCacheDays"] intValue];
    double secondsSinceUpdate = [self.lastUpdated timeIntervalSinceNow];
    if (secondsSinceUpdate < -1 * 60 * 60 * 24 * days) {
        return YES;
    }

    return NO;
}

- (void) getVoterInfoIfExpired:(void (^) (BOOL success, NSError *error)) statusBlock
{
    if ([self shouldUpdate]) {
        [self getVoterInfo:statusBlock];
    } else {
        statusBlock(YES, nil);
    }
}

/*
 A set of parsed data is unique on (electionId, UserAddress).
*/
- (void) getVoterInfo:(void (^) (BOOL success, NSError *error)) statusBlock
{
    if (![self.userAddress hasAddress]) {
        NSError *error = [VIPError errorWithCode:VIPError.InvalidUserAddress];
        statusBlock(NO, error);
    }
    NSString *settingsPath = [[NSBundle mainBundle] pathForResource:@"CivicAPIKey" ofType:@"plist"];
    NSDictionary *settings = [[NSDictionary alloc] initWithContentsOfFile:settingsPath];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // Serializes the http body POST parameters as JSON, which is what the Civic Info API expects
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *apiKey = [settings objectForKey:@"GoogleCivicInfoAPIKey"];
    NSDictionary *params = @{ @"address": self.userAddress.address };
    BOOL officialOnly = [[[AppSettings settings] objectForKey:@"OfficialOnly"] boolValue];
    NSString *officialOnlyString = officialOnly ? @"True" : @"False";

    NSString *urlFormat = @"https://www.googleapis.com/civicinfo/us_v1/voterinfo/%@/lookup?key=%@&officialOnly=%@";

    // Add query params to the url since AFNetworking serializes these internally anyway
    //  and the parameters parameter below attaches only to the http body for POST
    // Always use officialOnly = True
    if ([[AppSettings settings] valueForKey:@"DEBUG"]) {
        urlFormat = @"https://www.googleapis.com/civicinfo/us_v1/voterinfo/%@/lookup?key=%@&officialOnly=%@&productionDataOnly=false";
    }
    NSString *url =[NSString stringWithFormat:urlFormat, self.electionId, apiKey, officialOnlyString];
    NSLog(@"VoterInfo Query: %@", url);
    [manager POST:url
       parameters:params
          success:^(AFHTTPRequestOperation *operation, NSDictionary *json) {
              NSError *error = [self parseVoterInfoJSON:json];
              BOOL success = error ? NO : YES;
              statusBlock(success, error);
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              statusBlock(NO, error);
          }];
}

/*
 A set of parsed data is unique on (electionId, UserAddress).
*/
- (NSError*) parseVoterInfoJSON:(NSDictionary*)json
{
    NSError *error =[VIPError statusToError:json[@"status"]];
    if (error) {
        return error;
    }

    // First delete all old data
    [self deleteAllData];

    // Create the massive structure
    [self setFromDictionary:json];

    // Save ALL THE CHANGES
    NSManagedObjectContext *moc = [NSManagedObjectContext MR_defaultContext];
    [moc MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        NSLog(@"parseVoterInfoJSON saved: %d", success);
    }];
    return error;
}

- (void) setFromDictionary:(NSDictionary*)attributes
{
    // Parse Polling Locations
    NSArray *pollingLocations = attributes[@"pollingLocations"];
    for (NSDictionary *pollingLocation in pollingLocations) {
        PollingLocation *pl = [PollingLocation setFromDictionary:pollingLocation
                                               asEarlyVotingSite:NO];
        [self addPollingLocationsObject:pl];
    }

    // Parse polling locations
    NSArray *earlyVoteSites = attributes[@"earlyVoteSites"];
    for (NSDictionary *earlyVoteSite in earlyVoteSites) {
        PollingLocation *evs = [PollingLocation setFromDictionary:earlyVoteSite
                                                asEarlyVotingSite:YES];
        [self addPollingLocationsObject:evs];
    }

    // Parse States
    NSArray *states = attributes[@"state"];
    for (NSDictionary *state in states){
        [self addStatesObject:[State setFromDictionary:state]];
    }

    // Parse Contests
    NSArray *contests = attributes[@"contests"];
    for (NSDictionary *contest in contests){
        [self addContestsObject:[Contest setFromDictionary:contest]];
    }

    self.lastUpdated = [NSDate date];
}

- (void)stubReferendumData
{
#if DEBUG
    NSDictionary *referendumAttributes = @{@"type": @"Referendum",
                                           @"level": @"county",
                                           @"referendumTitle": @"Test Referendum",
                                           @"referendumSubtitle": @"This is a test referendum...",
                                           @"referendumUrl": @"http://votinginfoproject.org"};
    Contest *referendum = [Contest setFromDictionary:referendumAttributes];
    [self addContestsObject:referendum];
#endif
}

- (void) deleteAllData {
    [self deleteContests];
    [self deletePollingLocations];
    [self deleteStates];

    // get this save off the main thread!
    NSManagedObjectContext *moc = [NSManagedObjectContext MR_defaultContext];
    [moc MR_saveToPersistentStoreAndWait];
}

- (void) deleteStates
{
    for (State *state in self.states) {
        [state MR_deleteEntity];
    }
}

- (void) deletePollingLocations
{
    for (PollingLocation *pl in self.pollingLocations) {
        [pl MR_deleteEntity];
    }
}

- (void) deleteContests
{
    for (Contest *contest in self.contests) {
        [contest MR_deleteEntity];
    }
}


@end
