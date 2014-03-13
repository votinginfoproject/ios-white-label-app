//
//  Contest+API.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/5/14.
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
    [contest updateFromDictionary:mutableAttributes];

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

+ (NSDictionary*)propertyList
{
    static NSDictionary *propertyList = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        propertyList = @{
                              @"type": NSLocalizedString(@"Contest Type", nil),
                              @"primaryParty": NSLocalizedString(@"Primary Party", nil),
                              @"district.name": NSLocalizedString(@"District Name", nil),
                              @"district.id": NSLocalizedString(@"District ID", nil),
                              @"electorateSpecifications": NSLocalizedString(@"Electorate Specifications", nil),
                              @"special": NSLocalizedString(@"Special", nil),
                              @"level": NSLocalizedString(@"Level", nil),
                              @"numberElected": NSLocalizedString(@"Number Elected", nil),
                              @"numberVotingFor": NSLocalizedString(@"Number Voting For", nil),
                              @"ballotPlacement": NSLocalizedString(@"Ballot Placement", nil),
                              @"referendumSubtitle": NSLocalizedString(@"Referendum Subtitle", nil),
                              @"referendumUrl": NSLocalizedString(@"Referendum URL", nil),
                         };
    });
    return propertyList;
}

@end
