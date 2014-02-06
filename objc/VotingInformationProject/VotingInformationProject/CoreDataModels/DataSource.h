//
//  DataSource.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/4/14.
//  Copyright (c) 2014 Bennet Huber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Contest, PollingLocation, State;

@interface DataSource : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * official;
@property (nonatomic, retain) Contest *contest;
@property (nonatomic, retain) PollingLocation *pollingLocation;
@property (nonatomic, retain) State *state;

@end
