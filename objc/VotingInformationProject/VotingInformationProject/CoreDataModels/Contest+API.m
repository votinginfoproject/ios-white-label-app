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

- (NSMutableArray*)getContestProperties
{
    // Define the properties we want to retrieve since it appears there is no way
    //  to get this list in iOS, and we have to define the UI translated text anyways
    NSDictionary *propertyList = @{
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
    NSMutableArray *properties = [[NSMutableArray alloc] initWithCapacity:[propertyList count]];
    for (NSString *property in propertyList) {
        id data = [self valueForKeyPath:property];

        // Only parse and add strings/numbers, these are the properties
        if (data && [data isKindOfClass:[NSNumber class]]) {
            NSNumber *integerData = (NSNumber*)data;
            if (integerData.integerValue > 0) {
                [properties addObject:@{@"title": propertyList[property],
                                        @"data": integerData.stringValue}];
            }
        } else if (data && [data isKindOfClass:[NSString class]]) {
            NSString *stringData = (NSString*)data;
            [properties addObject:@{@"title": propertyList[property],
                                    @"data": stringData}];
        }
    }
    return properties;
}

@end
