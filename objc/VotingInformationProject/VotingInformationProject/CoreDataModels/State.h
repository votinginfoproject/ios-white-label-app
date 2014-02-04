//
//  State.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 1/31/14.
//  Copyright (c) 2014 Bennet Huber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DataSource, Election, ElectionAdministrationBody;

@interface State : NSManagedObject

@property (nonatomic, retain) NSString * stateId;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * localJurisdiction;
@property (nonatomic, retain) Election *election;
@property (nonatomic, retain) ElectionAdministrationBody *electionAdministrationBody;
@property (nonatomic, retain) NSSet *dataSource;
@end

@interface State (CoreDataGeneratedAccessors)

- (void)addDataSourceObject:(DataSource *)value;
- (void)removeDataSourceObject:(DataSource *)value;
- (void)addDataSource:(NSSet *)values;
- (void)removeDataSource:(NSSet *)values;

@end
