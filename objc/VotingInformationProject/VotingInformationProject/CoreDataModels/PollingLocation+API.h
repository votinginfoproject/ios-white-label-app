//
//  PollingLocation+API.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/3/14.
//  Copyright (c) 2014 Bennet Huber. All rights reserved.
//

#import "PollingLocation.h"
#import "DataSource.h"
#import "VIPAddress+API.h"

@interface PollingLocation (API)

- (void) setFromDictionary:(NSDictionary*)attributes
               withAddress:(NSDictionary*)address
           withDataSources:(NSArray*)dataSources;

@end
