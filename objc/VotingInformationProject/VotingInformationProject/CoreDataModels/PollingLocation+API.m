//
//  PollingLocation+API.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/3/14.
//  Copyright (c) 2014 Bennet Huber. All rights reserved.
//

#import "PollingLocation+API.h"
#import "DataSource.h"
#import "VIPAddress.h"

@implementation PollingLocation (API)

- (void) setFromDictionary:(NSDictionary *)attributes
               withAddress:(NSDictionary*)address
            withDataSources:(NSArray*)dataSources
{
    [self setValuesForKeysWithDictionary:attributes];

    for (NSDictionary *ds in dataSources) {
        DataSource *dataSource = [DataSource MR_createEntity];
        [dataSource setValuesForKeysWithDictionary:ds];
        [self addDataSourcesObject:dataSource];
    }

    VIPAddress *vipAddress = [VIPAddress MR_createEntity];
    [vipAddress setValuesForKeysWithDictionary:address];
    self.address = vipAddress;
}

@end
