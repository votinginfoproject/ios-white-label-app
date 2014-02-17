//
//  UserAddressAPITests.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/3/14.
//

#import <XCTest/XCTest.h>
#import "Kiwi.h"

#import "UserAddress+API.h"

SPEC_BEGIN(UserAddressAPITests)

describe(@"UserAddress+API", ^{
    
    beforeEach(^{
        [MagicalRecord setupCoreDataStackWithInMemoryStore];
    });
    
    afterEach(^{
        [MagicalRecord cleanUp];
    });

    it(@"should ensure that hasAddress returns true if address property is a non nil string w/ len > 0", ^{
        UserAddress *userAddress = [UserAddress MR_createEntity];
        userAddress.address = @"123 Test Drive";
        [[theValue([userAddress hasAddress]) should] equal:theValue(YES)];
    });

    it(@"should ensure that hasAddress returns false if address property is nil or has length 0", ^{
        UserAddress *userAddress = [UserAddress MR_createEntity];
        userAddress.address = nil;
        [[theValue([userAddress hasAddress]) should] equal:theValue(NO)];
        userAddress.address = @"";
        [[theValue([userAddress hasAddress]) should] equal:theValue(NO)];
    });

    it(@"should ensure that getUnique sets the address and lastUsed properties", ^{
        UserAddress *userAddress = [UserAddress getUnique:@"123 Test Drive"];
        [[userAddress.address should] equal:@"123 Test Drive"];
        [userAddress.lastUsed shouldNotBeNil];
    });

});

SPEC_END