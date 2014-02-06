//
//  CoreDataModelTests.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/3/14.
//  Copyright (c) 2014 Bennet Huber. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Kiwi.h"

#import "State+API.h"

SPEC_BEGIN(StateAPITests)

describe(@"StateAPITests", ^{
    
    beforeEach(^{
        [MagicalRecord setupCoreDataStackWithInMemoryStore];
    });
    
    afterEach(^{
        [MagicalRecord cleanUp];
    });

    it(@"should ensure that setDictionary sets empty objects with nil", ^{

        NSDictionary *attributes = @{};
        State *state = [State setFromDictionary:attributes];

        [[state.electionAdministrationBody shouldNot] beNil];
        [[state.electionAdministrationBody.name should] beNil];
        [[theValue([state.dataSources count]) should] equal:theValue(0)];
    });

    it(@"should ensure that setDictionary sets valid keys of PollingLocation", ^{

        NSString *namevalue = @"Hawaii";
        NSDictionary *attributes = @{
                                     @"name": namevalue,
                                     @"electionAdministrationBody": @{@"name": @"Test EAB"},
                                     @"sources": @[@{@"name": @"Test DataSource"}]
                                     };

        State *state = [State setFromDictionary:attributes];
        [[theValue([state.dataSources count]) should] equal:theValue(1)];
        [[state.electionAdministrationBody.name should] equal:@"Test EAB"];
        [[state.name should] equal:namevalue];
    });
   
});

SPEC_END
