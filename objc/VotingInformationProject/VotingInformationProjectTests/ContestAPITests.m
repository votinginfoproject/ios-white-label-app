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

});

SPEC_END
