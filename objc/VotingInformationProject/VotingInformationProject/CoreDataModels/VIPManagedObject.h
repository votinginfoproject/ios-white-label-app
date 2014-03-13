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

/**
 *  Init new object from a dictionary
 *
 *  Calls updateFromDictionary internally, see method docs for
 *  more info.
 *  Override if necessary to recurse through subclasses, see Contest+API for an example.
 *
 *  @param attributes Dict with keys to initialize
 *
 *  @return <#return value description#>
 */
+ (VIPManagedObject *) setFromDictionary:(NSDictionary*)attributes;

/**
 *  Update object attributes with the passed values
 *
 * Keys in the dictionary that do not exist on the object will be safely skipped.
 * This method does not recurse through subclasses.
 *
 * Ignores key with value "id" because this is a reserved objc type
 *
 *  @param attributes Dict with keys matching obj property names to update
 */
- (void) updateFromDictionary:(NSDictionary*)attributes;

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

@end
