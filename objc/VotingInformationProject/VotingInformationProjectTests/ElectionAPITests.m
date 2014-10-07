//
//  ElectionAPITests.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/5/14.
//

#import <XCTest/XCTest.h>
#import "Kiwi.h"

#import "UserElection+API.h"
#import "Contest.h"
#import "State.h"
#import "PollingLocation+API.h"

SPEC_BEGIN(ElectionAPITests)

describe(@"Election+API Tests", ^{

    beforeEach(^{
    });

    afterEach(^{
    });

    it(@"should ensure that filterPollingLocations returns only isEarlyVoteSite", ^{
        NSDictionary *attributes = @{
            @"kind": @"test",
            @"normalizedInput": @{ @"locationName": @"Test location" },
            @"election": @{
                @"id": @"2000",
                @"name": @"Test Election",
                @"electionDay": @"2013-01-01"
            },
            @"pollingLocations": @[@{}, @{}],
            @"earlyVoteSites": @[@{}]
        };
        NSError *error = nil;
       UserElection *votingInfo = [[UserElection alloc] initWithDictionary:attributes error:&error];

        NSArray *allSites = [votingInfo filterPollingLocations:VIPPollingLocationTypeAll];
        [[theValue([allSites count]) should] equal:theValue(3)];

        NSArray *earlyVoteSites = [votingInfo filterPollingLocations:VIPPollingLocationTypeEarlyVote];
        [[theValue([earlyVoteSites count]) should] equal:theValue(1)];

        NSArray *normalSites = [votingInfo filterPollingLocations:VIPPollingLocationTypeNormal];
        [[theValue([normalSites count]) should] equal:theValue(2)];
    });

    it(@"should ensure that getUniqueParties returns unique, alphabetically listed parties", ^{
        NSDictionary *attributes = @{
            @"kind": @"test",
            @"normalizedInput": @{ @"locationName": @"Test location" },
            @"election": @{
                @"id": @"2000",
                @"name": @"Test Election",
                @"electionDay": @"2013-01-01"
            },
            @"contests": @[
                @{@"primaryParty": @"foo"},
                @{@"primaryParty": @"bar"},
                @{@"primaryParty": @"foo"}
            ]
        };
        NSError *error = nil;
        UserElection *votingInfo = [[UserElection alloc] initWithDictionary:attributes error:&error];
        NSArray *parties = [votingInfo getUniqueParties];
        [[theValue([parties count]) should] equal:theValue(2)];
        [[parties[0] should] equal:@"bar"];
        [[parties[1] should] equal:@"foo"];
    });
});

SPEC_END
