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
        [MagicalRecord setupCoreDataStackWithInMemoryStore];
    });
    
    afterEach(^{
        [MagicalRecord cleanUp];
    });

    it(@"should ensure that uniqueUrl returns valid urls", ^{
        SocialChannel *channel = (SocialChannel*)[SocialChannel setFromDictionary:@{@"id": @"VotingInfo", @"type": @"Facebook"}];
        [[[[channel url] absoluteString] should] equal:@"https://facebook.com/VotingInfo"];

        channel.type = @"Twitter";
        [[[[channel url] absoluteString] should] equal:@"https://twitter.com/VotingInfo"];

        channel.type = @"BadSocialMediaPlatform";
        [[[channel url] should] beNil];
    });
   
});

SPEC_END
