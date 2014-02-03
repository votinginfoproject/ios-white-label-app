//
//  CoreDataModelTests.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/3/14.
//  Copyright (c) 2014 Bennet Huber. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Kiwi.h"

#import "Election+API.h"
#import "UserAddress+API.h"

SPEC_BEGIN(CoreDataModelsTests)

describe(@"CoreDataModels", ^{
    
    beforeEach(^{
        [MagicalRecord setupCoreDataStackWithInMemoryStore];
    });
    
    afterEach(^{
        [MagicalRecord cleanUp];
    });
   
    it(@"Election+API getOrCreate should return an instance with electionId set", ^{
        NSString * id1 = @"id1";
        Election *election1 = [Election getOrCreate:id1];
        [[theValue(id1) should] equal:theValue(election1.electionId)];

        [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *context) {}];

        // Test again, this time from CoreData since we saved above
        Election *election2 = [Election getOrCreate:id1];
        [[theValue(id1) should] equal:theValue(election2.electionId)];
    });
    
    it(@"Election+API getOrCreate should return nil if invalid electionId passed", ^{
        Election *election1 = [Election getOrCreate:nil];
        [election1 shouldBeNil];
        Election *election2 = [Election getOrCreate:@""];
        [election2 shouldBeNil];
    });

    it(@"UserAddress+API getByAddress should return nill if invalid address passed", ^{
        UserAddress *ua1 = [UserAddress getByAddress:nil];
        [ua1 shouldBeNil];
        UserAddress *ua2 = [UserAddress getByAddress:@""];
        [ua2 shouldBeNil];
    });

    it(@"UserAddress+API getByAddress should set address and lastUsed parameters", ^{
        NSString *address1 = @"340 N 12th St";
        NSDate *now = [NSDate date];
        UserAddress *ua1 = [UserAddress getByAddress:address1];
        [[theValue(address1) should] equal:theValue(ua1.address)];
        // ua1.lastUsed should now be greater than now
        [[theValue([ua1.lastUsed compare:now]) should] equal:theValue(NSOrderedDescending)];

        [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *context) {}];

        now = [NSDate date];
        UserAddress *ua2 = [UserAddress getByAddress:address1];
        // ua2.lastUsed should now be greater than now
        [[theValue([ua2.lastUsed compare:now]) should] equal:theValue(NSOrderedDescending)];
    });

});

SPEC_END