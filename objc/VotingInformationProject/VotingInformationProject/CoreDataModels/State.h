//
//  State.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 7/11/14.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DataSource, ElectionAdministrationBody, State, UserElection;

@interface State : VIPManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *dataSources;
@property (nonatomic, retain) ElectionAdministrationBody *electionAdministrationBody;
@property (nonatomic, retain) UserElection *userElection;
@property (nonatomic, retain) State *localJurisdiction;
@end

@interface State (CoreDataGeneratedAccessors)

- (void)addDataSourcesObject:(DataSource *)value;
- (void)removeDataSourcesObject:(DataSource *)value;
- (void)addDataSources:(NSSet *)values;
- (void)removeDataSources:(NSSet *)values;

@end
