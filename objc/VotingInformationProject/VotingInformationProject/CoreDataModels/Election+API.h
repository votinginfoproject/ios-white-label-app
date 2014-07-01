//
//  Election+API.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 6/24/14.
//

#import "Election.h"

@interface Election (API)

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
 *  Returns a unique Election instance, instantiating one if necessary
 *
 *  @param electionId Election ID to retrieve
 *
 *  @return Election instance
 */
+ (Election*)getUnique:(NSString*)electionId;

/**
 *  Get an NSDate for the current day with time set to localtime midnight
 *
 *  @return NSDate
 */
+ (NSDate*)today;

/**
 *  Get a list of elections that are in the future, sorted ascending by date
 *  Returned elections include elections on the current day.
 *
 *  @return NSArray of Election*
 */
+ (NSArray*)getFutureElections;

/**
 *  Checks if passed dictionary can be serialized into an Election object
 *  electionDay key requires date of the form YYYY-MM-DD
 *
 *  @param election NSDictionary with keys: id/name/electionDay
 *
 *  @return YES if valid, NO if not
 */
+ (BOOL) isElectionDictValid:(NSDictionary*)election;

+ (void)getElectionList:(void (^) (NSArray *elections, NSError *error)) resultsBlock;

@end
