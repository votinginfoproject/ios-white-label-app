//
//  Election.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/4/14.
//  Copyright (c) 2014 Bennet Huber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Contest, PollingLocation, State, UserAddress;

@interface Election : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * electionId;
@property (nonatomic, retain) NSString * electionName;
@property (nonatomic, retain) NSString * locationName;
@property (nonatomic, retain) NSSet *contests;
@property (nonatomic, retain) NSSet *pollingLocations;
@property (nonatomic, retain) NSSet *states;
@property (nonatomic, retain) UserAddress *userAddress;
@end

@interface Election (CoreDataGeneratedAccessors)

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
