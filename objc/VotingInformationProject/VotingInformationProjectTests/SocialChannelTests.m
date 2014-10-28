//
//  SocialChannelTests.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/3/14.
//

#import <XCTest/XCTest.h>
#import "Kiwi.h"

#import "SocialChannel+API.h"

SPEC_BEGIN(SocialChannelTests)

describe(@"SocialChannelTests", ^{
    
    beforeEach(^{
    });
    
    afterEach(^{
    });

    it(@"should ensure that uniqueUrl returns valid urls", ^{
        NSError *error = nil;
        SocialChannel *channel = [[SocialChannel alloc] initWithDictionary:@{@"id": @"https://facebook.com/VotingInfo", @"type": @"Facebook"}
                                                                     error:&error];
        [[[[channel url] absoluteString] should] equal:@"https://facebook.com/VotingInfo"];

    });
   
});

SPEC_END
