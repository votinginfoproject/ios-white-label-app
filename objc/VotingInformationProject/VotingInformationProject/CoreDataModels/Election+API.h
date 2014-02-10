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

/**
 Election+API is a category for Election that provides various convenience methods
 */

@interface Election (API)

/**
 Get a unique election from CoreData or create a new unique instance if it does not exist
 @warning The election instance is not automatically saved
 
 @param electionId The string id of the election
 @param userAddress The user address instance to match an election response to
 */
+ (Election *) getUnique:(NSString*)electionId
         withUserAddress:(UserAddress*)userAddress;

/**
 Get a list of elections for the specified UserAddress
 
 @param userAddress The userAddress to assign the election results to
 @param resultsBlock A block object to be executed when the operation completes. The block has no return value and takes two arguments: NSArray of elections return and an NSError that will contain any errors or nil if the operation completed successfully.
 */
+ (void) getElectionsAt:(UserAddress*)userAddress
                results:(void (^)(NSArray * elections, NSError * error))resultsBlock;

/**
 @return NSString of the form yyyy-mm-dd
 */
- (NSString *) getDateString;

/**
 @param stringDate NSString of the form yyyy-mm-dd
 */
- (void) setDateFromString:(NSString*)stringDate;

/**
 A helper function that determines if the election data contained in the Election object is stale. 

 @return YES if no valid election data or the data is stale, NO if the data is valid
 */
- (BOOL) shouldUpdate;

/**
 Get election data for an election from the Google Civic Info API, only if the data is stale as determined by shouldUpdate
 
 @see getVoterInfo:failure:
- (BOOL) getVoterInfoIfExpired:(void (^) (AFHTTPRequestOperation *operation, NSDictionary *json)) success
                       failure:(void (^) (AFHTTPRequestOperation *operation, NSError *error)) failure;

/**
 Get election data for an election from the Google Civic Info API

 https://developers.google.com/civic-information/docs/us_v1/elections/voterInfoQuery
 The API call is always made with officialOnly=True
 
 TODO: Refactor this method and combine with parseVoterInfoJSON: with arguments similar to getElectionsAt:results:
 
 @param success A block object to be executed when the operation completes. The block has no return value and takes two arguments that are the same as the success argument of the AFHTTPRequestOperationManager POST call.
 @param failure A block object to be executed when the operation completes with a failure. The block has no return value and takes two arguments that are the same as the failure argument of the AFHTTPRequestOperationManager POST call.
 */
- (void) getVoterInfo:(void (^) (AFHTTPRequestOperation *operation, NSDictionary *json)) success
              failure:(void (^) (AFHTTPRequestOperation *operation, NSError *error)) failure;

/**
 Load election data from a dictionary

 @param json The dictionary to load data from. It should follow the key/value pairs of the voterInfo query response: https://developers.google.com/civic-information/docs/us_v1/elections/voterInfoQuery
 */
- (void) parseVoterInfoJSON:(NSDictionary*)json;

/**
 Delete local CoreData cache of all of the election object's children.
 electionId, electionName, date and userAddress remain intact
 */
- (void) deleteAllData;

@end
