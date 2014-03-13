//
//  VIPManagedObject.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/6/14.
//  
//

#import "VIPManagedObject.h"

@implementation VIPManagedObject

+(NSDictionary*)propertyList
{
    static NSDictionary *propertyList = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        propertyList = @{
                 @"id": NSLocalizedString(@"ID", nil),
                 @"name": NSLocalizedString(@"Name", nil)
        };
    });
    return propertyList;
}

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

- (void)updateFromDictionary:(NSDictionary *)attributes
{
    NSMutableDictionary *mutableAttributes = [attributes mutableCopy];
    if ([mutableAttributes objectForKey:@"id"]) {
        [mutableAttributes removeObjectForKey:@"id"];
    }
    [self setValuesForKeysWithDictionary:mutableAttributes];
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
            [properties addObject:@{@"title": propertyList[property],
                                    @"data": stringData}];
        }
    }
    return properties;
}

@end
