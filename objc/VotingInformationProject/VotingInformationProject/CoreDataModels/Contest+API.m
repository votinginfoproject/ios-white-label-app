//
//  Contest+API.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 10/6/14.
//

#import "Contest+API.h"

@implementation Contest (API)

+ (NSDictionary*)propertyList
{
    static NSDictionary *propertyList = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        propertyList = @{
                              @"type": NSLocalizedString(@"Contest Type", @"Label in contest details section for contest type"),
                              @"primaryParty": NSLocalizedString(@"Primary Party", @"Label in contest details section for party in primary"),
                              @"district.name": NSLocalizedString(@"District Name", @"Label in contest details section for the district"),
                              @"electorateSpecifications": NSLocalizedString(@"Electorate Specifications", @"Label in contest details section for electorate specifications"),
                              @"special": NSLocalizedString(@"Special", @"Label in contest details section for special"),
                              @"level": NSLocalizedString(@"Level", @"Label in contest details section for level"),
                              @"numberElected": NSLocalizedString(@"Number Elected", @"Label in contest details section for # elected"),
                              @"numberVotingFor": NSLocalizedString(@"Number Voting For", @"Label in contest details section for # voting for"),
                              @"referendumSubtitle": NSLocalizedString(@"Referendum Subtitle", @"Label in contest details section for referendum subtitle"),
                              @"referendumUrl": NSLocalizedString(@"Referendum URL", @"Label in contest details section for referendum URL link"),
                         };
    });
    return propertyList;
}

@end
