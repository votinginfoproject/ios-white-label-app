//
//  VIPManagedObjectTests.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/6/14.
//  Copyright (c) 2014 Bennet Huber. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Kiwi.h"

#import "VIPManagedObject.h"
#import "VIPAddress+API.h"
#import "Contest+API.h"
#import "DataSource+API.h"

SPEC_BEGIN(VIPManagedObjectTests)

describe(@"VIPManagedObjectTests", ^{
    
    beforeEach(^{
        [MagicalRecord setupCoreDataStackWithInMemoryStore];
    });
    
    afterEach(^{
        [MagicalRecord cleanUp];
    });

    it(@"should ensure that setFromDictionary does not crash if invalid keys are passed", ^{
        // Cannot instantiate an abstract entity, so test the subclasses...
        NSString *validName = @"But this is a real key...";
        NSDictionary *attributes = @{@"IMANINVALIDKEYARGGHHH": @"No way is this a real key",
                                     @"name": validName,
                                     @"primaryParty": validName,
                                     @"locationName": validName};


        VIPAddress *vipAddress = (VIPAddress*)[VIPAddress setFromDictionary:attributes];
        [[vipAddress.locationName should] equal:validName];

        Contest *contest = (Contest*)[Contest setFromDictionary:attributes];
        [[contest.primaryParty should] equal:validName];

        DataSource *ds = (DataSource*)[DataSource setFromDictionary:attributes];
        [[ds.name should] equal:validName];
    });
   
});

SPEC_END

