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
#import "State+API.h"

SPEC_BEGIN(ElectionAdminBodyAPITests)

describe(@"ElectionAdminBodyAPITests", ^{
    
    beforeEach(^{
        [MagicalRecord setupCoreDataStackWithInMemoryStore];
    });
    
    afterEach(^{
        [MagicalRecord cleanUp];
    });

    it(@"should ensure that setFromDictionary can skip Candidates/DataSources/Districts", ^{
        NSDictionary *attributes = @{};
        ElectionAdministrationBody *testEab = [ElectionAdministrationBody setFromDictionary:attributes];
        [[theValue([testEab.electionOfficials count]) should] equal:theValue(0)];
        [[theValue([testEab.addresses count]) should] equal:theValue(0)];
        [[testEab.name should] beNil];
    });

    it(@"should ensure that setFromDictionary can set Officials/Addresses", ^{
        NSDictionary *attributes = @{
                                     @"electionOfficials": @[@{@"name": @"TestOfficial"}],
                                     @"correspondenceAddress": @{@"locationName": @"123 Test Drive"},
                                     @"physicalAddress": @{@"locationName": @"123 Test Suite"},
                                     @"name": @"EAB Test Name"
                                     };
        ElectionAdministrationBody *testEab = [ElectionAdministrationBody setFromDictionary:attributes];
        [[theValue([testEab.electionOfficials count]) should] equal:theValue(1)];
        [[theValue([testEab.addresses count]) should] equal:theValue(2)];
        [[testEab.name should] equal:@"EAB Test Name"];
    });

    it(@"should ensure that State Name is the first property returned in getProperties", ^{
        // Test required so that ElectionDetails view properly filters the state name for
        //  the local jurisdiction section
        NSDictionary *attributes = @{
                                     @"electionOfficials": @[@{@"name": @"TestOfficial"}],
                                     @"correspondenceAddress": @{@"locationName": @"123 Test Drive"},
                                     @"physicalAddress": @{@"locationName": @"123 Test Suite"},
                                     @"name": @"EAB Test Name"
                                     };
        NSDictionary *stateAttributes = @{@"name": @"Test State"};
        ElectionAdministrationBody *testEab = [ElectionAdministrationBody setFromDictionary:attributes];
        State *state = [State setFromDictionary:stateAttributes];
        testEab.state = state;
        NSMutableArray *properties = [testEab getProperties];
        NSDictionary *stateName = [properties objectAtIndex:0];
        [[theValue([properties count]) should] beGreaterThan:theValue(1)];
        [[stateName[@"data"] should] equal:@"Test State"];
    });

});

SPEC_END
