//
//  VotingInformationProjectTests.m
//  VotingInformationProjectTests
//
//  Created by Bennet Huber on 1/17/14.
//  Copyright (c) 2014 Bennet Huber. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Kiwi.h"

SPEC_BEGIN(VotingInformationProjectTests)

describe(@"SAMPLE TEST: Kiwi", ^{
    it(@"is pretty cool", ^{
        NSUInteger a = 16;
        NSUInteger b = 26;
        [[theValue(a + b) should] equal:theValue(42)];
    });
});

SPEC_END
