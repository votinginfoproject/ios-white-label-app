//
//  PollingLocation.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/4/14.
//  Copyright (c) 2014 Bennet Huber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DataSource, Election, VIPAddress;

@interface PollingLocation : NSManagedObject

@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) NSNumber * isEarlyVoteSite;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSString * pollingHours;
@property (nonatomic, retain) NSString * pollingLocationId;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSString * voterServices;
@property (nonatomic, retain) NSSet *dataSource;
@property (nonatomic, retain) Election *election;
@property (nonatomic, retain) VIPAddress *address;
@end

@interface PollingLocation (CoreDataGeneratedAccessors)

- (void)addDataSourceObject:(DataSource *)value;
- (void)removeDataSourceObject:(DataSource *)value;
- (void)addDataSource:(NSSet *)values;
- (void)removeDataSource:(NSSet *)values;

@end
