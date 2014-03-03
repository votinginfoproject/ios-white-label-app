//
//  Election+API.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 1/31/14.
//  
//

#import "AFNetworking/AFNetworking.h"

#import "Election.h"
#import "UserAddress+API.h"
#import "Contest+API.h"
#import "PollingLocation+API.h"
#import "State+API.h"

/**
 Election+API is a category for Election that provides various convenience methods
 */

@interface Election (API)

// Error domain for this class for use in NSError
extern NSString * const VIPErrorDomain;

// Error codes used by this class and elsewhere in NSError
// Get localized string descriptions with
//  + (NSString*)localizedDescriptionForErrorCode:
extern NSUInteger const VIPNoValidElections;
extern NSUInteger const VIPInvalidUserAddress;
extern NSUInteger const VIPAddressUnparseable;
extern NSUInteger const VIPNoAddress;
extern NSUInteger const VIPElectionUnknown;
extern NSUInteger const VIPElectionOver;
extern NSUInteger const VIPGenericAPIError;

// Definitions for the various possible responses from the voterInfo API
extern NSString * const APIResponseSuccess;
extern NSString * const APIResponseElectionOver;
extern NSString * const APIResponseElectionUnknown;
extern NSString * const APIResponseNoStreetSegmentFound;
extern NSString * const APIResponseMultipleStreetSegmentsFound;
extern NSString * const APIResponseNoAddressParameter;

/**
 * Get a unique election from CoreData or create a new unique instance if it does not exist
 * @warning The election instance is not automatically saved
 *
 * @param electionId The string id of the election
 * @param userAddress The user address instance to match an election response to
 */
+ (Election *) getUnique:(NSString*)electionId
         withUserAddress:(UserAddress*)userAddress;

/**
 *  Returns a statically allocated description for the errorCode
 *
 *  @param errorCode One of the VIP error codes defined in this header file
 *  @return NSString localized description for the error. Returns VIPGenericAPIError if no match.
 */
+ (NSString *)localizedDescriptionForErrorCode:(NSUInteger)errorCode;

/**
 * Get a list of elections for the specified UserAddress
 *
 * @param userAddress The userAddress to assign the election results to
 * @param resultsBlock A block object to be executed when the operation completes. 
 *      The block has no return value and takes two arguments: NSArray of elections
 *      return and an NSError that will contain any errors or nil if the operation completed successfully.
 */
+ (void) getElectionsAt:(UserAddress*)userAddress
           resultsBlock:(void (^)(NSArray * elections, NSError * error))resultsBlock;

/**
 * @return NSString of the form yyyy-mm-dd
 */
- (NSString *) getDateString;

/**
 * @param stringDate NSString of the form yyyy-mm-dd
 */
- (void) setDateFromString:(NSString*)stringDate;

/**
 *  Filter polling locations based on type
 *
 *  @param type One of enum VIPPollingLocationsType
 *
 *  @return NSArray of polling locations for this election that match the filter
 */
- (NSArray*)filterPollingLocations:(VIPPollingLocationType)type;

/**
 * A helper function that determines if the election data contained in the Election object is stale.
 *
 * @return YES if no valid election data or the data is stale, NO if the data is valid
 */
- (BOOL) shouldUpdate;

/**
 * Get election data for an election from the Google Civic Info API, only if the data is stale as determined by shouldUpdate
 *
 * @see getVoterInfo:
 */

- (void) getVoterInfoIfExpired:(void (^) (BOOL success, NSError *error)) statusBlock;

/**
 * Get election data for an election from the Google Civic Info API
 *
 * https://developers.google.com/civic-information/docs/us_v1/elections/voterInfoQuery
 * The API call is always made with officialOnly=True
 *
 * @param statusBlock A block object that executes when the operation completes, fills NSError param if success is NO
 */
- (void) getVoterInfo:(void (^) (BOOL success, NSError *error)) statusBlock;

/**
 * Load election data from a dictionary
 *
 * Used internally by getVoterInfo:
 *
 * @param json The dictionary to load data from. It should follow the key/value pairs of the 
 * voterInfo query response: https://developers.google.com/civic-information/docs/us_v1/elections/voterInfoQuery
 *
 * @return NSError with localizedDescription set if an error, otherwise nil
 */
- (NSError*) parseVoterInfoJSON:(NSDictionary*)json;

/**
 * Delete local CoreData cache of all of the election object's children.
 * electionId, electionName, date and userAddress remain intact
 */
- (void) deleteAllData;

@end
