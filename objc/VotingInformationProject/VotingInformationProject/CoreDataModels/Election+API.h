//
//  Election+API.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 6/24/14.
//

#import "Election.h"

@interface Election (API)

/**
 * @return NSString date using NSDateFormatterMediumStyle and no time component 
 */
- (NSString *) getDateString;

/**
 *  Election expires the day after it is valid for. This method compares "now" with
 *      electionDay at 00Z + 1 day. If now is after that date, election is expired
 *
 *  @return YES if election is expired, NO otherwise, returns YES if electionDay is nil
 */
- (BOOL)isExpired;

/**
 *  Get a NSDateFormatter configured for the date string format of the election object
 *
 *  @return NSDateFormatter init with format yyyy-MM-dd
 */
+ (NSDateFormatter*)getElectionDateFormatter;

/**
 *  Get an NSDate for the current day with time set to localtime midnight
 *
 *  @return NSDate
 */
+ (NSDate*)today;

@end
