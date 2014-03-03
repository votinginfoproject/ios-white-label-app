//
//  VIPManagedObject.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/6/14.
//  
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

- (NSArray*)getSorted:(NSString*)property
           byProperty:(NSString *)propertyKey
            ascending:(BOOL)isAscending
{
    NSArray *results = nil;
    NSSet *vipSet = [self valueForKey:property];
    if (vipSet && [vipSet respondsToSelector:@selector(allObjects)]) {
        SEL stringSelector = @selector(caseInsensitiveCompare:);
        SEL keySelector = @selector(compare:);
        // set selector -- caseInsensitiveCompare for NSString 
        //  otherwise default to compare:
        if ([[vipSet valueForKey:propertyKey] respondsToSelector:stringSelector]) {
            keySelector = stringSelector;
        }
        NSSortDescriptor *nameDescriptor = [NSSortDescriptor sortDescriptorWithKey:propertyKey
                                                                         ascending:isAscending
                                                                          selector:keySelector];
        NSArray *sortDescriptors = [NSArray arrayWithObject:nameDescriptor];
        NSArray *unsortedResults = [[self valueForKey:property] allObjects];
        results = [unsortedResults sortedArrayUsingDescriptors:sortDescriptors];
    }
    return results;
}

@end
