//
//  State+API.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/5/14.
//  Copyright (c) 2014 Bennet Huber. All rights reserved.
//

#import "State.h"
#import "ElectionAdministrationBody+API.h"
#import "DataSource+API.h"

@interface State (API)

+ (State*) setFromDictionary:(NSDictionary*) attributes;

@end
