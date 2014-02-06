//
//  Contest+API.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/5/14.
//  Copyright (c) 2014 Bennet Huber. All rights reserved.
//

#import "Contest+API.h"

@implementation Contest (API)

+ (Contest*) setFromDictionary:(NSDictionary *)attributes
{
    NSMutableDictionary *mutableAttributes = [attributes mutableCopy];

    NSString *candidatesKey = @"candidates";
    NSArray *candidates = attributes[candidatesKey];
    [mutableAttributes removeObjectForKey:candidatesKey];

    NSString *dataSourcesKey = @"sources";
    NSArray *dataSources = attributes[dataSourcesKey];
    [mutableAttributes removeObjectForKey:dataSourcesKey];

    NSString *districtKey = @"district";
    NSDictionary *districtDict = attributes[districtKey];
    [mutableAttributes removeObjectForKey:districtKey];

    Contest *contest = [Contest MR_createEntity];
    // Set attributes
    [contest setValuesForKeysWithDictionary:mutableAttributes];

    // Set district
    contest.district = (District*)[District setFromDictionary:districtDict];

    // Set DataSources
    for (NSDictionary *dataSource in dataSources) {
        [contest addDataSourcesObject:(DataSource*)[DataSource setFromDictionary:dataSource]];
    }

    // Set Candidates
    for (NSDictionary *candidate in candidates) {
        [contest addCandidatesObject:[Candidate setFromDictionary:candidate]];
    }

    return contest;
}
@end
