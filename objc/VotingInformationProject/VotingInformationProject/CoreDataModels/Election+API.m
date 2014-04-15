//
//  Election+API.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 1/31/14.
//  
//

#import "Election+API.h"
#import "AppSettings.h"

@implementation Election (API)


+ (Election*) getUnique:(NSString*)electionId
        withUserAddress:(UserAddress*)userAddress
{
    Election *election = nil;
    if (electionId && [electionId length] > 0 && [userAddress hasAddress]) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"electionId == %@ && userAddress == %@", electionId, userAddress];
        election = [Election MR_findFirstWithPredicate:predicate];
        if (!election) {
            election = [Election MR_createEntity];
            election.electionId = electionId;
            election.userAddress = userAddress;
#if DEBUG
            NSLog(@"Created new election with id: %@", electionId);
#endif
        } else {
#if DEBUG
            NSLog(@"Retrieved election %@ from data store", electionId);
#endif
        }
    }
    return election;
}

+ (void) getElectionsAt:(UserAddress*)userAddress
           resultsBlock:(void (^)(NSArray * elections, NSError * error))resultsBlock
{
    if (![userAddress hasAddress]) {
        NSError *error = [VIPError errorWithCode:VIPError.NoAddress];
        resultsBlock(@[], error);
        return;
    }

    // TODO: Attempt to get stored elections from the cache and display those rather than
    //          making a network request
    NSArray *elections = [Election MR_findByAttribute:@"userAddress"
                                            withValue:userAddress
                                           andOrderBy:@"date"
                                            ascending:YES];
    if ([elections count] > 0) {
        NSLog(@"Elections from cache for user address: %@", userAddress.address);
        BOOL foundRequested = NO;
        NSString *requestedElectionId = [[AppSettings settings] valueForKey:@"ElectionID"];
        for (Election *e in elections) {
            if ([requestedElectionId isEqualToString:e.electionId]) {
                foundRequested = YES;
                break;
            }
        }
        if (foundRequested) {
            NSLog(@"Election %@ requested found in cache.", requestedElectionId);
            resultsBlock(elections, nil);
            return;
        }
        NSLog(@"Election %@ requested and not found in cache. Attempting to fetch from election list...",
              requestedElectionId);
    }

    BOOL appDebug = [[[AppSettings settings] valueForKey:@"DEBUG"] boolValue];
    // Setup request manager
    // TODO: Refactor into separate class if multiple requests are made
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes
                                                         setByAddingObjectsFromSet:[NSSet setWithObject:@"text/plain"]];

    NSString *requestUrl = [[AppSettings settings] objectForKey:@"ElectionListURL"];
    NSLog(@"URL: %@", requestUrl);
    NSDictionary *requestParams = nil;

    [manager GET:requestUrl
      parameters:requestParams
         success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
             
             // On Success
             NSArray *electionData = [responseObject objectForKey:@"elections"];
             if (!electionData) {
                 // table view will simply be empty
                 NSError *error = [VIPError errorWithCode:VIPError.NoValidElections];
                 resultsBlock(@[], error);
                 return;
             }

             // Init elections array
             NSUInteger numberOfElections = [electionData count];
             NSMutableArray *elections = [[NSMutableArray alloc] initWithCapacity:numberOfElections];

             // Loop elections and add valid ones to elections array
             for (NSDictionary *entry in electionData) {
                 // skip election if in the past and debug is disabled
                 if (!appDebug && ![Election isElectionDictValid:entry]) {
                     continue;
                 }

                 NSString *electionId = entry[@"id"];
                 Election *election = [Election getUnique:electionId
                                          withUserAddress:userAddress];
                 election.electionName = entry[@"name"];
                 [election setDateFromString:entry[@"electionDay"]];
                 [elections addObject:election];
             }

             // sort elections by date ascending now that theyre all in the future
             NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"date"
                                                                              ascending:YES];
             NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
             NSArray *sortedElections = [elections sortedArrayUsingDescriptors:sortDescriptors];
             NSManagedObjectContext *moc = [NSManagedObjectContext MR_defaultContext];
             [moc MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
                 resultsBlock(sortedElections, error);
             }];

         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             resultsBlock(@[], error);
         }];

}

+ (BOOL) isElectionDictValid:(NSDictionary*)election {
    if (!election[@"id"]) {
        return NO;
    }
    if (!election[@"name"]) {
        return NO;
    }
    // setup date formatter
    NSDateFormatter *yyyymmddFormatter = [[NSDateFormatter alloc] init];
    [yyyymmddFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *electionDate = [yyyymmddFormatter dateFromString:election[@"electionDay"]];
    // Show if election in future relative to current day midnight localtime
    NSCalendarUnit units = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents* comps = [[NSCalendar currentCalendar] components:units fromDate:[NSDate date]];
    comps.day = comps.day - 1;
    NSDate* todayMidnight = [[NSCalendar currentCalendar] dateFromComponents:comps];
    if ([electionDate compare:todayMidnight] != NSOrderedDescending) {
        return NO;
    }
    return YES;
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

- (NSString *) getDateString
{
    NSString *electionDateString = nil;
    if (self.date) {
        NSDateFormatter *yyyymmddFormatter = [[NSDateFormatter alloc] init];
        [yyyymmddFormatter setDateFormat:@"yyyy-mm-dd"];
        electionDateString = [yyyymmddFormatter stringFromDate:self.date];
    }
    return electionDateString;
}

- (void) setDateFromString:(NSString *)stringDate
{
    NSDateFormatter *yyyymmddFormatter = [[NSDateFormatter alloc] init];
    [yyyymmddFormatter setDateFormat:@"yyyy-mm-dd"];
    self.date = [yyyymmddFormatter dateFromString:stringDate];
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

    NSString *urlFormat = @"https://www.googleapis.com/civicinfo/us_v1/voterinfo/%@/lookup?key=%@&officialOnly=True";

    // Add query params to the url since AFNetworking serializes these internally anyway
    //  and the parameters parameter below attaches only to the http body for POST
    // Always use officialOnly = True
    if ([[AppSettings settings] valueForKey:@"DEBUG"]) {
        urlFormat = @"https://www.googleapis.com/civicinfo/us_v1/voterinfo/%@/lookup?key=%@&officialOnly=True&productionDataOnly=false";
    }
    NSString *url =[NSString stringWithFormat:urlFormat, self.electionId, apiKey];
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
