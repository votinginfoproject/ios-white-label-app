//
//  CoreDataModelTests.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/3/14.
//

#import <XCTest/XCTest.h>
#import "Kiwi.h"

SPEC_BEGIN(CoreDataModelsTests)

describe(@"SAMPLECoreDataModelsTest", ^{
    
    beforeEach(^{
        [MagicalRecord setupCoreDataStackWithInMemoryStore];
    });
    
    afterEach(^{
        [MagicalRecord cleanUp];
    });

    it(@"should do something", ^{
        // test here
    });
   
});

SPEC_END