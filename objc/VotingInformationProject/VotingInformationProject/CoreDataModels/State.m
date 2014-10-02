//
//  State.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 7/11/14.
//

#import "State.h"


@implementation State

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
        @"local_jurisdiction": @"localJurisdiction",
    }];
}

@end
