//
//  Candidate+API.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/6/14.
//  
//

#import "Candidate+API.h"

@implementation Candidate (API)

+ (Candidate*) setFromDictionary:(NSDictionary *)attributes
{
    NSMutableDictionary *mutableAttributes = [attributes mutableCopy];

    // TODO: Remove this section if we want to store channels later 
    NSString *channelsKey = @"channels";
    [mutableAttributes removeObjectForKey:channelsKey];

    Candidate *candidate = [Candidate MR_createEntity];
    // Set attributes
    [candidate setValuesForKeysWithDictionary:mutableAttributes];

    return candidate;
}
@end
