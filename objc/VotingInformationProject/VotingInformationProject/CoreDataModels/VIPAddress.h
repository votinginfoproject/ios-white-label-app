//
//  VIPAddress.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/4/14.
//  Copyright (c) 2014 Bennet Huber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "VIPManagedObject.h"

@class ElectionAdministrationBody, PollingLocation;

@interface VIPAddress : VIPManagedObject

@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * line1;
@property (nonatomic, retain) NSString * line2;
@property (nonatomic, retain) NSString * line3;
@property (nonatomic, retain) NSString * locationName;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSString * zip;
@property (nonatomic, retain) ElectionAdministrationBody *eab;
@property (nonatomic, retain) PollingLocation *pollingLocation;

@end
