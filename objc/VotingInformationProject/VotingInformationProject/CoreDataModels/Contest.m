//
//  Contest.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 1/31/14.
//  Copyright (c) 2014 Bennet Huber. All rights reserved.
//

#import "Contest.h"
#import "Candidate.h"
#import "DataSource.h"
#import "District.h"
#import "Election.h"


@implementation Contest

@dynamic contestId;
@dynamic type;
@dynamic primaryParty;
@dynamic electorateSpecifications;
@dynamic special;
@dynamic office;
@dynamic level;
@dynamic numberElected;
@dynamic numberVotingFor;
@dynamic ballotPlacement;
@dynamic referendumTitle;
@dynamic referendumSubtitle;
@dynamic referendumURL;
@dynamic dataSource;
@dynamic district;
@dynamic candidates;
@dynamic election;

@end
