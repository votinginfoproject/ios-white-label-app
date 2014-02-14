//
//  State.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/5/14.
//  
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DataSource, Election, ElectionAdministrationBody;

@interface State : VIPManagedObject

@property (nonatomic, retain) NSString * localJurisdiction;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *dataSources;
@property (nonatomic, retain) Election *election;
@property (nonatomic, retain) ElectionAdministrationBody *electionAdministrationBody;
@end

@interface State (CoreDataGeneratedAccessors)

- (void)addDataSourcesObject:(DataSource *)value;
- (void)removeDataSourcesObject:(DataSource *)value;
- (void)addDataSources:(NSSet *)values;
- (void)removeDataSources:(NSSet *)values;

@end
