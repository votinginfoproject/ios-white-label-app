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

    it(@"should ensure that getLinksDataArray results have hte proper dict keys", ^{
        Candidate *candidate = [Candidate MR_createEntity];
        candidate.email = @"test.email@somedomain.com";

        NSMutableArray *linksData = [candidate getLinksDataArray];
        // should only get data for email since candidateUrl and phone are null
        [[theValue([linksData count]) should] equal:theValue(1)];
        NSDictionary *emailData = linksData[0];
        [[emailData should] beKindOfClass:[NSDictionary class]];
        [[emailData[@"description"] should] beNonNil];
        [[emailData[@"buttonTitle"] should] beNonNil];
        [[emailData[@"url"] should] beNonNil];
        [[emailData[@"urlScheme"] should] beNonNil];

        // ensure emailData urlScheme is of type kCandidateLinkTypeEmail as well
        [[theValue([emailData[@"urlScheme"] integerValue]) should] equal:theValue(kCandidateLinkTypeEmail)];
    });
   
});

SPEC_END
