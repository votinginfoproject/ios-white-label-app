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
                              @"type": NSLocalizedString(@"Contest Type",
                                                @"Label in contest details section for contest type"),
                              @"primaryParty": NSLocalizedString(@"Primary Party",
                                            @"Label in contest details section for party in primary"),
                              @"district.name": NSLocalizedString(@"District Name",
                                                @"Label in contest details section for the district"),
                              @"district.id": NSLocalizedString(@"District ID",
                                                @"Label in contest details section for the district ID"),
                              @"electorateSpecifications": NSLocalizedString(@"Electorate Specifications",
                                    @"Label in contest details section for electorate specifications"),
                              @"special": NSLocalizedString(@"Special",
                                                    @"Label in contest details section for special"),
                              @"level": NSLocalizedString(@"Level",
                                                @"Label in contest details section for level"),
                              @"numberElected": NSLocalizedString(@"Number Elected",
                                                    @"Label in contest details section for # elected"),
                              @"numberVotingFor": NSLocalizedString(@"Number Voting For",
                                                @"Label in contest details section for # voting for"),
                              @"ballotPlacement": NSLocalizedString(@"Ballot Placement",
                                            @"Label in contest details section for ballot placement"),
                              @"referendumSubtitle": NSLocalizedString(@"Referendum Subtitle",
                                            @"Label in contest details section for referendum subtitle"),
                              @"referendumUrl": NSLocalizedString(@"Referendum URL",
                                            @"Label in contest details section for referendum URL link"),
                         };
    });
    return propertyList;
}

@end
