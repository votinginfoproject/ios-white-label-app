//
//  PollingLocation+API.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/3/14.
//  
//

#import "PollingLocation.h"
#import "DataSource+API.h"
#import "VIPAddress+API.h"

@interface PollingLocation (API)

/**
 *  The types of polling locations.
 *
 *  The integer values explicitly defined here match to the indices
 *  of the UISegmentedControl used on the PollingLocations page
 */
typedef enum {
    VIPPollingLocationTypeAll = 0,
    VIPPollingLocationTypeEarlyVote = 1,
    VIPPollingLocationTypeNormal = 2
} VIPPollingLocationType;

+ (PollingLocation*) setFromDictionary:(NSDictionary*)attributes
                     asEarlyVotingSite:(BOOL)isEarlyVotingSite;

@end
