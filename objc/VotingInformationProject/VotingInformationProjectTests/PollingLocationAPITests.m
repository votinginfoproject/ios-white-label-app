//
//  CoreDataModelTests.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/3/14.
//  Copyright (c) 2014 Bennet Huber. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Kiwi.h"

#import "PollingLocation+API.h"

SPEC_BEGIN(PollingLocationAPITests)

describe(@"PLAPITests", ^{
    
    beforeEach(^{
        [MagicalRecord setupCoreDataStackWithInMemoryStore];
    });
    
    afterEach(^{
        [MagicalRecord cleanUp];
    });

    it(@"should ensure that setDictionary sets empty objects with nil", ^{
        PollingLocation *pl = [PollingLocation MR_createEntity];

        [[theValue([pl.dataSources count]) should] equal:theValue(0)];
        [pl.address shouldBeNil];
        [pl setFromDictionary:nil withAddress:nil withDataSources:nil];
        [[theValue([pl.dataSources count]) should] equal:theValue(0)];
        [pl.address shouldNotBeNil];
    });

    it(@"should ensure that setDictionary sets valid keys of PollingLocation", ^{

        NSString *notesvalue = @"blanknotes";
        NSString *namevalue = @"site 1";
        NSNumber *isEVS = @YES;

        PollingLocation *pl = [PollingLocation MR_createEntity];
        NSDictionary *invalidAttribute = @{
                                           @"notes": notesvalue,
                                           @"name": namevalue,
                                           @"isEarlyVoteSite": isEVS
                                           };
        [pl.notes shouldBeNil];
        [pl.name shouldBeNil];
        [[pl.isEarlyVoteSite should] beNo];
        [pl setFromDictionary:invalidAttribute withAddress:nil withDataSources:nil];
        [[pl.notes should] equal:notesvalue];
        [[pl.name should] equal:namevalue];
        [[pl.isEarlyVoteSite should] beYes];
    });
   
});

SPEC_END