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

@end
