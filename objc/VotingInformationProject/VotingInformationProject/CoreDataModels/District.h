//
//  District.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 6/23/14.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Contest;

@interface District : VIPManagedObject

@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * scope;
@property (nonatomic, retain) NSSet *contests;
@end

@interface District (CoreDataGeneratedAccessors)

- (void)addContestsObject:(Contest *)value;
- (void)removeContestsObject:(Contest *)value;
- (void)addContests:(NSSet *)values;
- (void)removeContests:(NSSet *)values;

@end
