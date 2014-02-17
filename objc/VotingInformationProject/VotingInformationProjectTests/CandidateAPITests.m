//
//  CandidateAPITests.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/3/14.
//

#import <XCTest/XCTest.h>
#import "Kiwi.h"

#import "Candidate+API.h"

SPEC_BEGIN(CandidateAPITests)

describe(@"CandidateAPITests", ^{
    
    beforeEach(^{
        [MagicalRecord setupCoreDataStackWithInMemoryStore];
    });
    
    afterEach(^{
        [MagicalRecord cleanUp];
    });

    it(@"should ensure that getCandidatePhotoData sets data", ^{
        Candidate* candidate = [Candidate MR_createEntity];
        candidate.photoUrl = @"https://votinginfoproject.org/a/img/logo-vip.png";
        [[candidate.photo should] beNil];
        [candidate getCandidatePhotoData];
        [[expectFutureValue(candidate.photo) shouldEventuallyBeforeTimingOutAfter(2.0)] beNonNil];
    });
   
});

SPEC_END
