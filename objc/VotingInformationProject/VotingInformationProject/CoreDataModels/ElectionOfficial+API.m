//
//  ElectionOfficial+API.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/5/14.
//  Copyright (c) 2014 Bennet Huber. All rights reserved.
//

#import "ElectionOfficial+API.h"

@implementation ElectionOfficial (API)

+ (ElectionOfficial*) setFromDictionary:(NSDictionary *)attributes
{
    ElectionOfficial *electionOfficial = [ElectionOfficial MR_createEntity];
    [electionOfficial setValuesForKeysWithDictionary:attributes];
    return electionOfficial;
}

@end
