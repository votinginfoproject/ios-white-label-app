//
//  UserElection.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 6/24/14.
//

#import "UserElection.h"


@implementation UserElection

// initWithDictionary is the JSONModel designated initializer
- (instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err
{
    self = [super initWithDictionary:dict error:err];
    // Set these properties to empty arrays if not provided by API
    if (self) {
        if (!self.pollingLocations) {
            self.pollingLocations = @[];
        }
        if (!self.earlyVoteSites) {
            self.earlyVoteSites = @[];
        }
        if (!self.contests) {
            self.contests = @[];
        }
        if (!self.dropOffLocations) {
            self.dropOffLocations = @[];
        }
        if (!self.isMailOnly) {
            self.mailOnly = NO;
        }
    }
    return self;
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"mailOnly"]) {
        return YES;
    }
    return NO;
}

@end
