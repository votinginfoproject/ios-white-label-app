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

- (NSMutableURLRequest*)getFeedbackRequest;

@end
