//
//  VIPManagedObject.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/6/14.
//  Copyright (c) 2014 Bennet Huber. All rights reserved.
//
//  WARNING:

#import <CoreData/CoreData.h>

/**
 VIPManagedObject - easily create new objects in the VIP project from an NSDictionary
 
 @warning There does not appear to be a way to automatically have
        Editor -> "Create NSManagedObject classes" automatically subclass all of our
        CoreData model classes from VIPManagedObject. Ultra lame. So, don't use that feature
        or use it but then DO NOT forget to update all of the NSManagedObject refs to
        VIPManagedObject. Shouldn't be too hard with "Refactor" command
 
 */

@interface VIPManagedObject : NSManagedObject

/**
 Set object data from a dictionary.
 
 Keys in the dictionary that do not exist on the object will be safely skipped. This method does not recurse through subclasses.
 
 Override if necessary to recurse through subclasses, see Contest+API for an example.
 */
+ (VIPManagedObject *) setFromDictionary:(NSDictionary*)attributes;

@end
