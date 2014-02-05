//
//  Election+API.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 1/31/14.
//  Copyright (c) 2014 Bennet Huber. All rights reserved.
//

#import "Election+API.h"
#import "PollingLocation+API.h"
#import "VIPAddress.h"
#import "Contest.h"
#import "State.h"

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
            election.lastUpdated = [NSDate date];
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

// For now always yes to test delete/update on CoreData
- (BOOL) shouldUpdate
{
    // Update if no last updated date
    if (!self.lastUpdated) {
        return YES;
    }
    // Update if all of these are empty
    if (!(self.pollingLocations || self.contests || self.states)) {
        return YES;
    }
    // Update if election data is more than x days old
    int days = 7;
    double secondsSinceUpdate = [self.lastUpdated timeIntervalSinceNow];
    if (secondsSinceUpdate < -1 * 60 * 60 * 24 * days) {
        return YES;
    }

    return NO;
}

- (BOOL) getVoterInfoIfExpired:(void (^) (AFHTTPRequestOperation *operation, NSDictionary *json)) success
                       failure:(void (^) (AFHTTPRequestOperation *operation, NSError *error)) failure
{
    if ([self shouldUpdate]) {
        [self getVoterInfo:success failure:failure];
        return YES;
    } else {
        return NO;
    }

}

- (void) getVoterInfo:(void (^) (AFHTTPRequestOperation *operation, NSDictionary *json)) success
              failure:(void (^) (AFHTTPRequestOperation *operation, NSError *error)) failure
{
    if (![self.userAddress hasAddress]) {
        return;
    }
    NSString *settingsPath = [[NSBundle mainBundle] pathForResource:@"settings" ofType:@"plist"];
    NSDictionary *settings = [[NSDictionary alloc] initWithContentsOfFile:settingsPath];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // Serializes the http body POST parameters as JSON, which is what the Civic Info API expects
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *apiKey = [settings objectForKey:@"GoogleCivicInfoAPIKey"];
    NSDictionary *params = @{ @"address": self.userAddress.address };

    // Add query params to the url since AFNetworking serializes these internally anyway
    //  and the parameters parameter below attaches only to the http body for POST
    // Always use officialOnly = True
    NSString *urlFormat = @"https://www.googleapis.com/civicinfo/us_v1/voterinfo/%@/lookup?key=%@&officialOnly=True";
    NSString *url =[NSString stringWithFormat:urlFormat, self.electionId, apiKey];
    [manager POST:url
       parameters:params
          success:success
          failure:failure];
}

/*
 A set of parsed data is unique on (electionId, UserAddress).
 Each time we pull down data for a unique entry and we want to update the reference data, we will first
    delete all previous data associated with the unique entry. This needs to be done because child objects
    do not have a unique identifier and we don't want to update the wrong objects
 
 Some pseudocode for the above notes:
 Get list of objects with (electionId, userAddress)
 if list length is 0:
    create new entry and parse json
 else if list length > 0 and we want to update:
    delete old objects and reparse json
 else if list length > 0 and we do not want to update:
    do nothing

*/
- (void) parseVoterInfoJSON:(NSDictionary*)json
{
    NSString *status = json[@"status"];
    if (![status isEqualToString:@"success"]) {
        NSLog(@"Invalid voterInfo JSON status: %@", status);
        return;
    }

    // First delete all old data
    [self deleteAllData];

    [self parsePollingLocations:json[@"pollingLocations"]
                asEarlyVoteSite:NO];
    [self parsePollingLocations:json[@"earlyVoteSites"]
                asEarlyVoteSite:YES];

    self.lastUpdated = [NSDate date];
    // Save ALL THE CHANGES
    NSManagedObjectContext *moc = [NSManagedObjectContext MR_contextForCurrentThread];
    [moc MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        NSLog(@"parseVoterInfoJSON saved: %d", success);
    }];
}

- (void) parsePollingLocations:(NSArray*)pollingLocations
               asEarlyVoteSite:(BOOL) isEarlyVoteSite
{
    for (NSDictionary *location in pollingLocations) {
        PollingLocation *pollingLocation = [PollingLocation MR_createEntity];
        pollingLocation.isEarlyVoteSite = (isEarlyVoteSite) ? @YES : @NO;
        NSMutableDictionary *attributes = [location mutableCopy];
        [attributes removeObjectsForKeys:@[@"address", @"sources"]];
        [pollingLocation setFromDictionary:attributes
                               withAddress:location[@"address"]
                           withDataSources:location[@"sources"]];
        [self addPollingLocationsObject:pollingLocation];
    }
}

- (void) deleteAllData {
    [self deleteContests];
    [self deletePollingLocations];
    [self deleteStates];

    NSManagedObjectContext *moc = [NSManagedObjectContext MR_contextForCurrentThread];
    // get this save off the main thread!
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
