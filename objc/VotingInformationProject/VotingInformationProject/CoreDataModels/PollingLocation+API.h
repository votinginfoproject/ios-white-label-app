//
//  PollingLocation+API.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/3/14.
//  
//

#import "PollingLocation.h"

@interface PollingLocation (API)

/**
 *  The types of polling locations.
 *
 *  The integer values explicitly defined here match to the indices
 *  of the UISegmentedControl used on the PollingLocations page
 */
typedef enum {
    VIPPollingLocationTypeAll = 0,
    VIPPollingLocationTypeEarlyVote = 1,
    VIPPollingLocationTypeNormal = 2,
    VIPPollingLocationTypeDropbox = 3
} VIPPollingLocationType;

/**
 *  Returns status of PollingLocation
 *  Returns YES if current datetime is before the PollingLocation endDate,
 *  otherwise NO.
 *  If start_date or end_date is not a valid date of the form YYYY-MM-DD
 *  this method returns YES as per the voting information spec 3.0:
 *  http://votinginfoproject.github.io/vip-specification/#earlyvotesiteitems
 *
 *  @return BOOL See Above
 */
- (BOOL)isAvailable;

@end
