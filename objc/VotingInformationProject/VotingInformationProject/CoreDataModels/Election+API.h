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

#define ELECTIONSAPIErrorDomain @"Elections+API"
#define ELECTIONSAPIErrorCodeInvalidUserAddress 101
#define ELECTIONSAPIErrorDescriptionInvalidUserAddress @"A UserAddress Required"

@interface Election (API)

+ (Election *) getUnique:(NSString*)electionId
         withUserAddress:(UserAddress*)userAddress;

/*
    Argument to block is an array of newly retrieved and saved Election* objects
    Array will be empty if no elections were found
 */
+ (void) getElectionsAt:(UserAddress*)userAddress
                results:(void (^)(NSArray * elections, NSError * error))resultsBlock;

- (NSString *) getDateString;
- (void) setDateFromString:(NSString*)stringDate;

- (BOOL) shouldUpdate;

- (BOOL) getVoterInfoIfExpired:(void (^) (AFHTTPRequestOperation *operation, NSDictionary *json)) success
                       failure:(void (^) (AFHTTPRequestOperation *operation, NSError *error)) failure;

- (void) getVoterInfo:(void (^) (AFHTTPRequestOperation *operation, NSDictionary *json)) success
              failure:(void (^) (AFHTTPRequestOperation *operation, NSError *error)) failure;

- (void) parseVoterInfoJSON:(NSDictionary*)json;

- (void) deleteAllData;

@end
