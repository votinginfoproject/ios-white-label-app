//
//  Contest+API.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/5/14.
//  Copyright (c) 2014 Bennet Huber. All rights reserved.
//

#import "Contest.h"
#import "Candidate+API.h"
#import "DataSource+API.h"
#import "District+API.h"


@interface Contest (API)

+ (Contest*) setFromDictionary:(NSDictionary*)attributes;

@end
