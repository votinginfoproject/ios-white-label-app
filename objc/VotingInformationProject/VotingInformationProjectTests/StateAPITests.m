//
//  CoreDataModelTests.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/3/14.
//

#import <XCTest/XCTest.h>
#import "Kiwi.h"

#import "State.h"

SPEC_BEGIN(StateAPITests)

describe(@"StateAPITests", ^{
    
    beforeEach(^{
    });
    
    afterEach(^{
    });

    it(@"should ensure that initWithDictionary sets empty objects with nil", ^{

        NSDictionary *attributes = @{};
        NSError *error = nil;
        State *state = [[State alloc] initWithDictionary:attributes error:&error];

        [[state.electionAdministrationBody should] beNil];
        [[theValue([state.dataSources count]) should] equal:theValue(0)];
    });

    it(@"should ensure that setDictionary sets valid keys of PollingLocation", ^{

        NSString *namevalue = @"Hawaii";
        NSDictionary *attributes = @{
                                     @"name": namevalue,
                                     @"electionAdministrationBody": @{@"name": @"Test EAB"},
                                     @"dataSources": @[@{@"name": @"Test DataSource", @"official": @"true"}]
                                     };
        NSError *error = nil;
        State *state = [[State alloc] initWithDictionary:attributes error:&error];
        [[theValue([state.dataSources count]) should] equal:theValue(1)];
        [[state.electionAdministrationBody.name should] equal:@"Test EAB"];
        [[state.name should] equal:namevalue];
    });
   
});

SPEC_END
