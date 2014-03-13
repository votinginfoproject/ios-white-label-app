//
//  VIPManagedObject.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/6/14.
//  

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

+ (NSDictionary*)propertyList;

/**
 Set object data from a dictionary.
 
 Keys in the dictionary that do not exist on the object will be safely skipped. This method does not recurse through subclasses.
 
 Override if necessary to recurse through subclasses, see Contest+API for an example.
 */
+ (VIPManagedObject *) setFromDictionary:(NSDictionary*)attributes;

/**
 Get a sorted array from an VIPManagedObject NSSet property
 
 @warning passing an invalid propertyKey will return an array, but unsorted
 
 @param property The NSSet property to sort
 @param propertyKey The key of the property to sort on
 @param ascending YES if sort ascending, NO sort descending
 @return NSArray of the sorted objects, nil if bad property is provided
 */
- (NSArray*)getSorted:(NSString*)property
           byProperty:(NSString *)propertyKey
            ascending:(BOOL)isAscending;


/**
 Gets a subset of the properties of contest and returns them as an array,
 where each object in the array is an NSDictionary of hte following form:
 
 Default property list returns id and name (if available). Override in subclass,
 See Contest+API for an example

 @{
   "title": <NSLocalizedString of the title to display for this property>
   "data": <The data to display, as an NSString
  }
 
 @return NSMutableArray of NSDictionaries of the form specified above
 */
- (NSMutableArray*)getProperties;

@end
