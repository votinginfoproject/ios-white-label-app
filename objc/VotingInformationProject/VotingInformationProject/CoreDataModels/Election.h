//
//  Election.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 1/31/14.
//  Copyright (c) 2014 Bennet Huber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Contest, DataSource, PollingLocation, State;

@interface Election : NSManagedObject

@property (nonatomic, retain) NSString * electionId;
@property (nonatomic, retain) NSString * electionName;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * locationName;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSNumber * addressLat;
@property (nonatomic, retain) NSNumber * addressLon;
@property (nonatomic, retain) NSSet *dataSource;
@property (nonatomic, retain) NSSet *states;
@property (nonatomic, retain) NSSet *pollingLocations;
@property (nonatomic, retain) NSSet *contests;
@end

@interface Election (CoreDataGeneratedAccessors)

- (void)addDataSourceObject:(DataSource *)value;
- (void)removeDataSourceObject:(DataSource *)value;
- (void)addDataSource:(NSSet *)values;
- (void)removeDataSource:(NSSet *)values;

- (void)addStatesObject:(State *)value;
- (void)removeStatesObject:(State *)value;
- (void)addStates:(NSSet *)values;
- (void)removeStates:(NSSet *)values;

- (void)addPollingLocationsObject:(PollingLocation *)value;
- (void)removePollingLocationsObject:(PollingLocation *)value;
- (void)addPollingLocations:(NSSet *)values;
- (void)removePollingLocations:(NSSet *)values;

- (void)addContestsObject:(Contest *)value;
- (void)removeContestsObject:(Contest *)value;
- (void)addContests:(NSSet *)values;
- (void)removeContests:(NSSet *)values;

@end
