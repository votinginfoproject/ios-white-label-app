//
//  UserAddress+API.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/3/14.
//  Copyright (c) 2014 Bennet Huber. All rights reserved.
//

#import "UserAddress+API.h"

@implementation UserAddress (API)

+ (UserAddress*)getUnique:(NSString *)address
{
    UserAddress* userAddress = nil;
    if (address && [address length] > 0) {
        userAddress = [UserAddress MR_findFirstByAttribute:@"address" withValue:address];
        if (!userAddress) {
            userAddress = [UserAddress MR_createEntity];
            userAddress.address = address;
        }
        userAddress.lastUsed = [NSDate date];
    }
    return userAddress;
}

@end
