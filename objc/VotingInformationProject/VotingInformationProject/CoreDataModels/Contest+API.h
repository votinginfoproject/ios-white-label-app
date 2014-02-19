//
//  Contest+API.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/5/14.
//

#import "Contest.h"
#import "Candidate+API.h"
#import "DataSource+API.h"
#import "District+API.h"


@interface Contest (API)

/**
 Create and return an instance of Contest from a dictionary

 @param attributes NSDictionary of the attributes to set
 
 @see VIPManagedObject setFromDictionary:
 */
+ (Contest*)setFromDictionary:(NSDictionary*)attributes;

/**
 Gets a subset of the properties of contest and returns them as an array,
 where each object in the array is an NSDictionary of hte following form:

 @{
   "title": <NSLocalizedString of the title to display for this property>
   "data": <The data to display, as an NSString
  }
 
 @return NSMutableArray of NSDictionaries of the form specified above
 */
- (NSMutableArray*)getContestProperties;

@end
