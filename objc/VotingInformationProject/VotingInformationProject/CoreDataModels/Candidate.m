//
//  Candidate.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 6/23/14.
//

#import "Candidate.h"


@implementation Candidate

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    if ([propertyName isEqualToString:@"orderOnBallot"]) {
        return YES;
    } else {
        return [super propertyIsOptional:propertyName];
    }
}

@end
