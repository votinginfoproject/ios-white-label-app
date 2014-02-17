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

+ (PollingLocation*) setFromDictionary:(NSDictionary*)attributes
                     asEarlyVotingSite:(BOOL)isEarlyVotingSite;

@end
