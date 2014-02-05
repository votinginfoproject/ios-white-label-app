//
//  VIPAddress+API.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/5/14.
//  Copyright (c) 2014 Bennet Huber. All rights reserved.
//

#import "VIPAddress+API.h"

@implementation VIPAddress (API)

+ (VIPAddress*) setFromDictionary:(NSDictionary*)address
{
    VIPAddress *vipAddress = [VIPAddress MR_createEntity];
    [vipAddress setValuesForKeysWithDictionary:address];
    return vipAddress;
}

@end
