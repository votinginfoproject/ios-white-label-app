//
//  PollingLocation+API.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/3/14.
//  Copyright (c) 2014 Bennet Huber. All rights reserved.
//

#import "PollingLocation+API.h"

@implementation PollingLocation (API)

+ (PollingLocation*) setFromDictionary:(NSDictionary *)attributes
                     asEarlyVotingSite:(BOOL)isEarlyVotingSite;
{
    NSMutableDictionary *mutableAttributes = [attributes mutableCopy];

    NSString *dataSourcesKey = @"sources";
    NSArray *dataSources = attributes[dataSourcesKey];
    [mutableAttributes removeObjectForKey:dataSourcesKey];

    NSString *addressKey = @"address";
    NSDictionary *address = attributes[addressKey];
    [mutableAttributes removeObjectForKey:addressKey];

    PollingLocation *pollingLocation = [PollingLocation MR_createEntity];
    pollingLocation.isEarlyVoteSite = @(isEarlyVotingSite);
    [pollingLocation setValuesForKeysWithDictionary:mutableAttributes];

    pollingLocation.address = [VIPAddress setFromDictionary:address];

    for (NSDictionary *dataSource in dataSources) {
        [pollingLocation addDataSourcesObject:[DataSource setFromDictionary:dataSource]];
    }

    return pollingLocation;
}

@end
