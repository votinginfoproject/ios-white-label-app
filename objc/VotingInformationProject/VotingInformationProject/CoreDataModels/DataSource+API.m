//
//  DataSource+API.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/5/14.
//  Copyright (c) 2014 Bennet Huber. All rights reserved.
//

#import "DataSource+API.h"

@implementation DataSource (API)

+ (DataSource*) setFromDictionary:(NSDictionary *)attributes
{
    DataSource *dataSource = [DataSource MR_createEntity];
    [dataSource setValuesForKeysWithDictionary:attributes];
    return dataSource;
}

@end
