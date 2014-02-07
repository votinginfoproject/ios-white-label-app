//
//  VIPManagedObject.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/6/14.
//  Copyright (c) 2014 Bennet Huber. All rights reserved.
//
//  WARNING: There does not appear to be a way to automatically have
//      Editor -> "Create NSManagedObject classes" automatically subclass all of our
//      CoreData model classes from VIPManagedObject. Ultra lame. So, don't use that feature
//      or use it but then DO NOT forget to update all of the NSManagedObject refs to
//      VIPManagedObject. Shouldn't be too hard with "Refactor" command

#import <CoreData/CoreData.h>

@interface VIPManagedObject : NSManagedObject

+ (VIPManagedObject *) setFromDictionary:(NSDictionary*)attributes;

@end
