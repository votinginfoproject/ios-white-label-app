//
//  UserAddress.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 3/4/14.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "VIPManagedAddress.h"

@class Election;

@interface UserAddress : VIPManagedAddress

@property (nonatomic, retain) NSDate * lastUsed;
@property (nonatomic, retain) NSSet *elections;
@end

@interface UserAddress (CoreDataGeneratedAccessors)

- (void)addElectionsObject:(Election *)value;
- (void)removeElectionsObject:(Election *)value;
- (void)addElections:(NSSet *)values;
- (void)removeElections:(NSSet *)values;

@end
