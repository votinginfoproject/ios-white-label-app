//
//  DataSource.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/4/14.
//  Copyright (c) 2014 Bennet Huber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Contest, Election, PollingLocation, State;

@interface DataSource : NSManagedObject

@property (nonatomic, retain) NSNumber * isOfficial;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *contest;
@property (nonatomic, retain) NSSet *election;
@property (nonatomic, retain) NSSet *pollingLocation;
@property (nonatomic, retain) NSSet *state;
@end

@interface DataSource (CoreDataGeneratedAccessors)

- (void)addContestObject:(Contest *)value;
- (void)removeContestObject:(Contest *)value;
- (void)addContest:(NSSet *)values;
- (void)removeContest:(NSSet *)values;

- (void)addElectionObject:(Election *)value;
- (void)removeElectionObject:(Election *)value;
- (void)addElection:(NSSet *)values;
- (void)removeElection:(NSSet *)values;

- (void)addPollingLocationObject:(PollingLocation *)value;
- (void)removePollingLocationObject:(PollingLocation *)value;
- (void)addPollingLocation:(NSSet *)values;
- (void)removePollingLocation:(NSSet *)values;

- (void)addStateObject:(State *)value;
- (void)removeStateObject:(State *)value;
- (void)addState:(NSSet *)values;
- (void)removeState:(NSSet *)values;

@end
