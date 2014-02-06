//
//  VIPManagedObject.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/6/14.
//  Copyright (c) 2014 Bennet Huber. All rights reserved.
//

#import "VIPManagedObject.h"

@implementation VIPManagedObject


// Override so that our use of setValuesForKeysWithDictionary
// does not crash the app when an undefined key is passed
- (void) setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"VIPManagedObject key %@ does not exist", key);
    return;
}

- (id) valueForUndefinedKey:(NSString *)key
{
    return nil;
}

+ (VIPManagedObject*) setFromDictionary:(NSDictionary *)attributes
{
    VIPManagedObject *vipObject = [self MR_createEntity];
    [vipObject setValuesForKeysWithDictionary:attributes];
    return vipObject;
}

@end
