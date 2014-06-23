//
//  UserElection+API.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 1/31/14.
//  
//

#import "AFNetworking/AFNetworking.h"

#import "VIPError.h"
#import "UserElection.h"
#import "UserAddress+API.h"
#import "Contest+API.h"
#import "PollingLocation+API.h"
#import "State+API.h"

/**
 UserElection+API is a category for Election that provides various convenience methods
 */

@interface UserElection (API)

/**
 * Get a unique election from CoreData or create a new unique instance if it does not exist
 * @warning The election instance is not automatically saved
 *
 * @param electionId The string id of the election
 * @param userAddress The user address instance to match an election response to
 */
+ (UserElection *) getUnique:(NSString*)electionId
         withUserAddress:(UserAddress*)userAddress;

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
 *  Get list of all the unique parties in this election sorted alphabetically
 *
 *  @return NSArray of NSString containing the unique parties
 */
- (NSArray*)getUniqueParties;

/**
 * @return NSString of the form yyyy-mm-dd
 */
- (NSString *) getDateString;

/**
 * @param stringDate NSString of the form yyyy-mm-dd
 */
- (void) setDateFromString:(NSString*)stringDate;

/**
 *  Get a NSDateFormatter configured for the date string format of the election object
 *
 *  @return NSDateFormatter init with format yyyy-MM-dd
 */
+ (NSDateFormatter*)getElectionDateFormatter;

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
