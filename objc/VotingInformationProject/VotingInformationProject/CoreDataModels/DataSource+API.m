//
//  DataSource+API.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/4/14.
//  Copyright (c) 2014 Bennet Huber. All rights reserved.
//

#import "DataSource+API.h"

@implementation DataSource (API)

/*
 Return: true if the object was deleted
         false if not
 
// TODO: Should override the methods of MR_delete*
*/
- (BOOL) deleteObject {
    // Logic here should include only deleting if all of this object's
    //  NSSets are empty/nil
    return NO;
}

+ (DataSource*) getUnique:(NSString*)name
{
    DataSource *objectInstance = nil;
    if (name && [name length] > 0) {
        objectInstance = [DataSource MR_findFirstByAttribute:@"name" withValue:name];
        if (!objectInstance) {
            objectInstance = [DataSource MR_createEntity];
            objectInstance.name = name;
            objectInstance.isOfficial = @YES;    // For VIP, we will always use official sources
#if DEBUG
            NSLog(@"DataSource: NEW %@", name);
#endif
        } else {
#if DEBUG
            NSLog(@"DataSource: FETCH CoreData %@", name);
#endif
        }
    }
    return objectInstance;
}

@end
