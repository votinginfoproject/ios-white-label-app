//
//  PollingLocation.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 1/31/14.
//  Copyright (c) 2014 Bennet Huber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DataSource, Election;

@interface PollingLocation : NSManagedObject

@property (nonatomic, retain) NSString * pollingLocationId;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSNumber * addressLat;
@property (nonatomic, retain) NSNumber * addressLon;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) NSString * pollingHours;
@property (nonatomic, retain) NSNumber * isEarlyVoteSite;
@property (nonatomic, retain) NSString * voterServices;
@property (nonatomic, retain) NSSet *dataSource;
@property (nonatomic, retain) Election *election;
@end

@interface PollingLocation (CoreDataGeneratedAccessors)

- (void)addDataSourceObject:(DataSource *)value;
- (void)removeDataSourceObject:(DataSource *)value;
- (void)addDataSource:(NSSet *)values;
- (void)removeDataSource:(NSSet *)values;

@end
