//
//  CivicInfoAPI.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 10/6/14.
//

#import <Foundation/Foundation.h>

#import "UserElection.h"
#import "Election.h"

@interface CivicInfoAPI : NSObject

+ (void) getVotingInfo:(NSString*)address
           forElection:(Election*)election
              callback:(void (^) (UserElection* votingInfo, NSError *error)) statusBlock;

@end
