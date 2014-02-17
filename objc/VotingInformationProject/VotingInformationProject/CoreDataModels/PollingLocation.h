//
//  PollingLocation.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/4/14.
//  
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DataSource, Election, VIPAddress;

@interface PollingLocation : VIPManagedObject

@property (nonatomic, retain) NSString * endDate;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSNumber * isEarlyVoteSite;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSString * pollingHours;
@property (nonatomic, retain) NSString * startDate;
@property (nonatomic, retain) NSString * voterServices;
@property (nonatomic, retain) VIPAddress *address;
@property (nonatomic, retain) NSSet *dataSources;
@property (nonatomic, retain) Election *election;
@end

@interface PollingLocation (CoreDataGeneratedAccessors)

- (void)addDataSourcesObject:(DataSource *)value;
- (void)removeDataSourcesObject:(DataSource *)value;
- (void)addDataSources:(NSSet *)values;
- (void)removeDataSources:(NSSet *)values;

@end
