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
    });
    
    afterEach(^{
    });
    
    it(@"should ensure that Contest propertyList contains more than the default number of entries", ^{
        NSDictionary *properties = [Contest propertyList];
        [[theValue([properties count]) should] beGreaterThan:theValue(5)];
    });

    it(@"should ensure that Contest propertyList contains custom properties", ^{
        NSDictionary *properties = [Contest propertyList];
        [[[properties objectForKey:@"type"] shouldNot] beNil];
        [[[properties objectForKey:@"primaryParty"] shouldNot] beNil];
        [[[properties objectForKey:@"level"] shouldNot] beNil];
    });

    it(@"should ensure that setFromDictionary can set Candidates/DataSources/Districts", ^{
        NSDictionary *attributes = @{
                                     @"candidates": @[@{@"name": @"TestCandidate"}],
                                     @"sources": @[@{@"name": @"TestDataSource", @"official": @"z"}],
                                     @"district": @{@"id": @"TestDistrict"},
                                     @"type": @"Primary"
                                     };
        NSError *error = nil;
        Contest *testContest = [[Contest alloc] initWithDictionary:attributes error:&error];
        [[theValue([testContest.candidates count]) should] equal:theValue(1)];
        [[theValue([testContest.sources count]) should] equal:theValue(1)];
        [[testContest.district.id should] equal:@"TestDistrict"];
        [[testContest.type should] equal:@"Primary"];
    });

    it(@"should ensure that setFromDictionary can skip Candidates/DataSources/Districts", ^{
        NSDictionary *attributes = @{
                                     @"type": @"Primary"
                                     };
        NSError *error = nil;
        Contest *testContest = [[Contest alloc] initWithDictionary:attributes error:&error];
        [[testContest.candidates should] beNil];
        [[testContest.sources should] beNil];
        [[testContest.district should] beNil];
        [[testContest.district.id should] beNil];
        [[testContest.type should] equal:@"Primary"];
    });

});

SPEC_END
