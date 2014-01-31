//
//  DataSource.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 1/31/14.
//  Copyright (c) 2014 Bennet Huber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Contest, Election, PollingLocation, State;

@interface DataSource : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * isOfficial;
@property (nonatomic, retain) Election *election;
@property (nonatomic, retain) PollingLocation *pollingLocation;
@property (nonatomic, retain) Contest *contest;
@property (nonatomic, retain) State *state;

@end
