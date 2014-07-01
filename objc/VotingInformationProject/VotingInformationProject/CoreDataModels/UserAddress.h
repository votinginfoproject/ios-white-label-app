//
//  UserAddress.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 6/23/14.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "VIPManagedAddress.h"

@class UserElection;

@interface UserAddress : VIPManagedAddress

@property (nonatomic, retain) NSDate * lastUsed;
@property (nonatomic, retain) NSSet *userElections;
@end

@interface UserAddress (CoreDataGeneratedAccessors)

- (void)addUserElectionsObject:(UserElection *)value;
- (void)removeUserElectionsObject:(UserElection *)value;
- (void)addUserElections:(NSSet *)values;
- (void)removeUserElections:(NSSet *)values;

@end
