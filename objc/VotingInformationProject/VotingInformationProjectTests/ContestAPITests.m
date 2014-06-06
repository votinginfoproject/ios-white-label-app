//
//  ContestAPITests.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/6/14.
//

#import <XCTest/XCTest.h>
#import "Kiwi.h"
#import "Contest+API.h"

SPEC_BEGIN(ContestAPITests)

describe(@"ContestAPITests", ^{
    
    beforeEach(^{
        [MagicalRecord setupCoreDataStackWithInMemoryStore];
    });
    
    afterEach(^{
        [MagicalRecord cleanUp];
    });

    it(@"should ensure that setFromDictionary can set Candidates/DataSources/Districts", ^{
        NSDictionary *attributes = @{
                                     @"candidates": @[@{@"name": @"TestCandidate"}],
                                     @"sources": @[@{@"name": @"TestDataSource"}],
                                     @"district": @{@"id": @"TestDistrict"},
                                     @"type": @"Primary"
                                     };
        Contest *testContest = [Contest setFromDictionary:attributes];
        [[theValue([testContest.candidates count]) should] equal:theValue(1)];
        [[theValue([testContest.dataSources count]) should] equal:theValue(1)];
        [[testContest.district.id should] equal:@"TestDistrict"];
        [[testContest.type should] equal:@"Primary"];
    });

    it(@"should ensure that setFromDictionary can skip Candidates/DataSources/Districts", ^{
        NSDictionary *attributes = @{
                                     @"type": @"Primary"
                                     };
        Contest *testContest = [Contest setFromDictionary:attributes];
        [[theValue([testContest.candidates count]) should] equal:theValue(0)];
        [[theValue([testContest.dataSources count]) should] equal:theValue(0)];
        [[testContest.district shouldNot] beNil];
        [[testContest.district.id should] beNil];
        [[testContest.type should] equal:@"Primary"];
    });

    it(@"should ensure that getContestProperties returns array w/ dict w/ keys title & data", ^{
        NSDictionary *attributes = @{@"type": @"Primary"};
        Contest *testContest = [Contest setFromDictionary:attributes];

        NSMutableArray *contestProperties = [testContest getProperties];
        [[theValue([contestProperties count]) should] equal:theValue(1)];

        NSDictionary *entry = contestProperties[0];
        [[entry should] beKindOfClass:[NSDictionary class]];
        [[entry[@"title"] should] beNonNil];
        [[entry[@"data"] should] beNonNil];
    });

});

SPEC_END
