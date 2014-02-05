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

        NSDictionary *attributes = @{};
        PollingLocation *pl = [PollingLocation setFromDictionary:attributes asEarlyVotingSite:YES];

        [[pl.isEarlyVoteSite should] beYes];
        [[pl.address shouldNot] beNil];
        [[pl.address.locationName should] beNil];
        [[theValue([pl.dataSources count]) should] equal:theValue(0)];
    });

    it(@"should ensure that setDictionary sets valid keys of PollingLocation", ^{

        NSString *notesvalue = @"blanknotes";
        NSString *namevalue = @"site 1";
        NSDictionary *attributes = @{
                                     @"notes": notesvalue,
                                     @"name": namevalue
                                     };

        PollingLocation *pl = [PollingLocation setFromDictionary:attributes asEarlyVotingSite:NO];
        [[pl.isEarlyVoteSite should] beNo];
        [[pl.notes should] equal:notesvalue];
        [[pl.name should] equal:namevalue];
    });
   
});

SPEC_END