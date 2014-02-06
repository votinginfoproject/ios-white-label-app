//
//  District.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/4/14.
//  Copyright (c) 2014 Bennet Huber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Contest;

@interface District : NSManagedObject

@property (nonatomic, retain) NSString * districtId;
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
