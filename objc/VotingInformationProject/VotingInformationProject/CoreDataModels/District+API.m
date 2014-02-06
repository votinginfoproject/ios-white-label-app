//
//  District+API.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/6/14.
//  Copyright (c) 2014 Bennet Huber. All rights reserved.
//

#import "District+API.h"

@implementation District (API)

+ (District*)   setFromDictionary:(NSDictionary *)attributes
{
    District *district = [District MR_createEntity];
    [district setValuesForKeysWithDictionary:attributes];
    return district;
}

@end
