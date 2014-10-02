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
