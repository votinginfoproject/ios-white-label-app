//
//  Candidate+API.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/6/14.
//  Copyright (c) 2014 Bennet Huber. All rights reserved.
//

#import "Candidate+API.h"

@implementation Candidate (API)

+ (Candidate*) setFromDictionary:(NSDictionary *)attributes
{
    NSMutableDictionary *mutableAttributes = [attributes mutableCopy];

    // TODO: Readd channels object if we want to store this info
    NSString *channelsKey = @"channels";
    [mutableAttributes removeObjectForKey:channelsKey];

    Candidate *candidate = [Candidate MR_createEntity];
    // Set attributes
    [candidate setValuesForKeysWithDictionary:mutableAttributes];

    return candidate;
}
@end
