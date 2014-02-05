//
//  Election+API.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 1/31/14.
//  Copyright (c) 2014 Bennet Huber. All rights reserved.
//

#import "AFNetworking/AFNetworking.h"

#import "Election.h"
#import "UserAddress+API.h"
#import "Contest+API.h"
#import "PollingLocation+API.h"
#import "State+API.h"

@interface Election (API)

+ (Election *) getUnique:(NSString*)electionId
         withUserAddress:(UserAddress*)userAddress;

- (BOOL) shouldUpdate;

- (BOOL) getVoterInfoIfExpired:(void (^) (AFHTTPRequestOperation *operation, NSDictionary *json)) success
                       failure:(void (^) (AFHTTPRequestOperation *operation, NSError *error)) failure;

- (void) getVoterInfo:(void (^) (AFHTTPRequestOperation *operation, NSDictionary *json)) success
              failure:(void (^) (AFHTTPRequestOperation *operation, NSError *error)) failure;

- (void) parseVoterInfoJSON:(NSDictionary*)json;

- (void) deleteAllData;

@end
