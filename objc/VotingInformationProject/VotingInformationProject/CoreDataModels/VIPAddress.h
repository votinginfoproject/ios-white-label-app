//
//  VIPAddress.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/4/14.
//  Copyright (c) 2014 Bennet Huber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Election, ElectionAdministrationBody, PollingLocation;

@interface VIPAddress : NSManagedObject

@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * line1;
@property (nonatomic, retain) NSString * line2;
@property (nonatomic, retain) NSString * line3;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSString * zip;
@property (nonatomic, retain) Election *election;
@property (nonatomic, retain) PollingLocation *pollingLocation;
@property (nonatomic, retain) ElectionAdministrationBody *eab;

@end
