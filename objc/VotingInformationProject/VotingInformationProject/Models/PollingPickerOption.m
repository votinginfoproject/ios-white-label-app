//
//  PollingPickerOption.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 10/27/14.
//

#import "PollingPickerOption.h"

@implementation PollingPickerOption

-(instancetype)initWithType:(VIPPollingLocationType)type andDescription:(NSString *)desc
{
    self = [super init];
    if (self) {
        self.type = type;
        self.desc = desc;
    }
    return self;
}

- (instancetype)init
{
    return [self initWithType:VIPPollingLocationTypeAll andDescription:nil];
}

@end
