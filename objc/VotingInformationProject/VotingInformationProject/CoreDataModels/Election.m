//
//  Election.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 1/31/14.
//  Copyright (c) 2014 Bennet Huber. All rights reserved.
//

#import "Election.h"
#import "Contest.h"
#import "DataSource.h"
#import "PollingLocation.h"
#import "State.h"


@implementation Election

@dynamic electionId;
@dynamic electionName;
@dynamic date;
@dynamic locationName;
@dynamic address;
@dynamic addressLat;
@dynamic addressLon;
@dynamic dataSource;
@dynamic states;
@dynamic pollingLocations;
@dynamic contests;

@end
