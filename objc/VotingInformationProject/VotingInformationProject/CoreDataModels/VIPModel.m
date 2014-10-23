//
//  VIPModel.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 10/6/14.
//

#import "VIPModel.h"

@implementation VIPModel

+(NSDictionary*)propertyList
{
    static NSDictionary *propertyList = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        propertyList = @{
                         @"id": NSLocalizedString(@"ID", @"Generic label for a property ID"),
                         @"name": NSLocalizedString(@"Name", @"Generic label for a property name")
                         };
    });
    return propertyList;
}

- (NSMutableArray*)getProperties
{
    NSDictionary *propertyList = [[self class] propertyList];
    NSMutableArray *properties = [[NSMutableArray alloc] initWithCapacity:[propertyList count]];
    for (NSString *property in propertyList) {
        id data = [self valueForKeyPath:property];

        // Only parse and add strings/numbers, these are the properties
        if (data && [data isKindOfClass:[NSNumber class]]) {
            NSNumber *integerData = (NSNumber*)data;
            if (integerData.integerValue > 0) {
                [properties addObject:@{@"title": propertyList[property],
                                        @"data": integerData.stringValue}];
            }
        } else if (data && [data isKindOfClass:[NSString class]]) {
            NSString *stringData = (NSString*)data;
            if ([data length] > 0) {
                [properties addObject:@{@"title": propertyList[property],
                                        @"data": stringData}];
            }
        }
    }
    if ([properties count] == 0) {
        [properties addObject:@{
            @"title": NSLocalizedString(@"Not Available", nil),
            @"data": @""
        }];
    }
    return properties;
}

@end
