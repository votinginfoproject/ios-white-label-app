//
//  UserElection.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 6/24/14.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Election.h"

@class Contest, PollingLocation, State, UserAddress;

@interface UserElection : Election

@property (nonatomic, retain) NSDate * lastUpdated;
@property (nonatomic, retain) NSSet *contests;
@property (nonatomic, retain) NSSet *pollingLocations;
@property (nonatomic, retain) NSSet *states;
@property (nonatomic, retain) UserAddress *userAddress;
@end

@interface UserElection (CoreDataGeneratedAccessors)

- (void)addContestsObject:(Contest *)value;
- (void)removeContestsObject:(Contest *)value;
- (void)addContests:(NSSet *)values;
- (void)removeContests:(NSSet *)values;

- (void)addPollingLocationsObject:(PollingLocation *)value;
- (void)removePollingLocationsObject:(PollingLocation *)value;
- (void)addPollingLocations:(NSSet *)values;
- (void)removePollingLocations:(NSSet *)values;

- (void)addStatesObject:(State *)value;
- (void)removeStatesObject:(State *)value;
- (void)addStates:(NSSet *)values;
- (void)removeStates:(NSSet *)values;

@end
