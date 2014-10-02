//
//  UserElection+API.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 1/31/14.
//

#import "AFNetworking/AFNetworking.h"

#import "VIPError.h"
#import "UserElection.h"
#import "PollingLocation+API.h"

/**
 UserElection+API is a category for Election that provides various convenience methods
 */

@interface UserElection (API)

/**
 *  Get list of all the unique parties in this election sorted alphabetically
 *
 *  @return NSArray of NSString containing the unique parties
 */
- (NSArray*)getUniqueParties;

- (NSArray*)filterPollingLocations:(VIPPollingLocationType)type;

/**
 * Get election data for an election from the Google Civic Info API
 *
 * https://developers.google.com/civic-information/docs/us_v1/elections/voterInfoQuery
 * The API call is always made with officialOnly=True
 *
 * @param statusBlock A block object that executes when the operation completes, fills NSError param if success is NO
 */
//- (void) getVoterInfo:(void (^) (BOOL success, NSError *error)) statusBlock;

@end
