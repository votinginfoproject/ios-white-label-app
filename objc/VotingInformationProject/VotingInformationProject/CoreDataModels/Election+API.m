//
//  Election+API.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 1/31/14.
//  Copyright (c) 2014 Bennet Huber. All rights reserved.
//

#import "Election+API.h"
#import "PollingLocation+API.h"

@implementation Election (API)

+ (Election*) getUnique:(NSString*)electionId
{
    Election *election = nil;
    if (electionId && [electionId length] > 0) {
        election = [Election MR_findFirstByAttribute:@"electionId" withValue:electionId];
        if (!election) {
            election = [Election MR_createEntity];
            election.electionId = electionId;
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

- (void) getVoterInfoAt:(NSString*)address
         isOfficialOnly:(BOOL)isOfficialOnly
                success:(void (^) (AFHTTPRequestOperation *operation, NSDictionary *json)) success
                failure:(void (^) (AFHTTPRequestOperation *operation, NSError *error)) failure
{

    if (!address || [address length] == 0) {
        return;
    }
    NSString *settingsPath = [[NSBundle mainBundle] pathForResource:@"settings" ofType:@"plist"];
    NSDictionary *settings = [[NSDictionary alloc] initWithContentsOfFile:settingsPath];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // Serializes the http body POST parameters as JSON, which is what the Civic Info API expects
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *apiKey = [settings objectForKey:@"GoogleCivicInfoAPIKey"];
    NSString *officialOnly = (isOfficialOnly) ? @"True" : @"False";
    NSDictionary *params = @{ @"address": address };

    // Add query params to the url since AFNetworking serializes these internally anyway
    //  and the parameters parameter below attaches only to the http body for POST
    NSString *urlFormat = @"https://www.googleapis.com/civicinfo/us_v1/voterinfo/%@/lookup?key=%@&officialOnly=%@";
    NSString *url =[NSString stringWithFormat:urlFormat, self.electionId, apiKey, officialOnly];
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
            withUserAddress:(UserAddress*)userAddress
{
    NSString *status = json[@"status"];
    if (![status isEqualToString:@"success"]) {
        NSLog(@"Invalid voterInfo JSON status: %@", status);
        return;
    }

    [self parsePollingLocations:json[@"pollingLocations"]];

}

- (void) parsePollingLocations:(NSArray*)pollingLocations
{
    for (NSDictionary *location in pollingLocations) {
        NSString *plId = location[@"address"][@"locationName"];
        PollingLocation *pollingLocation = [PollingLocation getUnique:plId];
        [pollingLocation setFromDictionary:@{
                                             @"notes": location[@"notes"],
                                             @"pollingHours": location[@"pollingHours"],
                                             @"name": plId,
                                             @"isEarlyVoteSite": @NO
                                             }];
        [self addPollingLocationsObject:pollingLocation];
    }
}

@end
