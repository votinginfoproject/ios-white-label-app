//
//  PollingLocation.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 1/31/14.
//  Copyright (c) 2014 Bennet Huber. All rights reserved.
//

#import "PollingLocation.h"
#import "DataSource.h"
#import "Election.h"


@implementation PollingLocation

@dynamic pollingLocationId;
@dynamic address;
@dynamic addressLat;
@dynamic addressLon;
@dynamic notes;
@dynamic name;
@dynamic startDate;
@dynamic endDate;
@dynamic pollingHours;
@dynamic isEarlyVoteSite;
@dynamic voterServices;
@dynamic dataSource;
@dynamic election;

@end
