//
//  ElectionAdminBodyAPITests.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/6/14.
//

#import <XCTest/XCTest.h>

#import <XCTest/XCTest.h>
#import "Kiwi.h"
#import "ElectionAdministrationBody+API.h"

SPEC_BEGIN(ElectionAdminBodyAPITests)

describe(@"ElectionAdminBodyAPITests", ^{
    
    beforeEach(^{
    });
    
    afterEach(^{
    });

    it(@"should ensure that setFromDictionary can skip Candidates/DataSources/Districts", ^{
        NSDictionary *attributes = @{};
        NSError *error = nil;
        ElectionAdministrationBody *testEab = [[ElectionAdministrationBody alloc]
                                               initWithDictionary:attributes error:&error];
        [[theValue([testEab.electionOfficials count]) should] equal:theValue(0)];
        [[testEab.physicalAddress should] beNil];
        [[testEab.name should] beNil];
    });

    it(@"should ensure that setFromDictionary can set Officials/Addresses", ^{
        NSDictionary *attributes = @{
                                     @"electionOfficials": @[@{@"name": @"TestOfficial"}],
                                     @"correspondenceAddress": @{@"locationName": @"123 Test Drive"},
                                     @"physicalAddress": @{@"locationName": @"123 Test Suite"},
                                     @"name": @"EAB Test Name"
                                     };
        NSError *error = nil;
        ElectionAdministrationBody *testEab = [[ElectionAdministrationBody alloc]
                                               initWithDictionary:attributes error:&error];
        [[theValue([testEab.electionOfficials count]) should] equal:theValue(1)];
        [[testEab.correspondenceAddress should] beNonNil];
        [[testEab.physicalAddress should] beNonNil];
        [[testEab.name should] equal:@"EAB Test Name"];
    });
});

SPEC_END
