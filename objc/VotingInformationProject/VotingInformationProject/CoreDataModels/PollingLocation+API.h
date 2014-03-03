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

typedef enum {
    kPollingLocationTypeAll = 0,
    kPollingLocationTypeEarlyVote = 1,
    kPollingLocationTypeNormal = 2
} kPollingLocationType;

+ (PollingLocation*) setFromDictionary:(NSDictionary*)attributes
                     asEarlyVotingSite:(BOOL)isEarlyVotingSite;

@end
