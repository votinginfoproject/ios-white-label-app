//
//  AppSettingsTests.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/3/14.
//

#import <XCTest/XCTest.h>
#import "Kiwi.h"

#import "AppSettings.h"

SPEC_BEGIN(AppSettingsTests)

describe(@"AppSettingsTests", ^{

    beforeEach(^{
    });

    afterEach(^{
    });

    it(@"should ensure that getValue:withDefault: returns default for missing key", ^{
        NSString *testKey = @"ImNotOrEverWillBeARealKey";
        id testValue = [[AppSettings settings] objectForKey:testKey];
        id testValueDefault = [AppSettings valueForKey:testKey withDefault:@"DEFAULT!"];
        [[testValue should] beNil];
        [[testValueDefault should] equal:@"DEFAULT!"];
    });
});

SPEC_END
