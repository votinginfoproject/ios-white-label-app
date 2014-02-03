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

SPEC_BEGIN(CoreDataModelsTests)

describe(@"CoreDataModels", ^{
    
    beforeEach(^{
        //[MagicalRecord setupDefaultModelWithClass:[self class]];
        [MagicalRecord setupCoreDataStackWithInMemoryStore];
    });
    
    afterEach(^{
        [MagicalRecord cleanUp];
    });
   
    it(@"Election+API getOrCreate should return an instance with electionId set", ^{
        NSString * id1 = @"id1";
        Election *election1 = [Election getOrCreate:id1];
        [[theValue(id1) should] equal:theValue(election1.electionId)];

        [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *context) {
            
        }];
        
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
    
    //describe(@"Election+API getOrCreate should return existing instance if it exists", ^{
        //NSString * id1 = @"id1";
        //Election *election1 = [Election getOrCreate:id1];
        //id subject =
    //});
    
});

SPEC_END