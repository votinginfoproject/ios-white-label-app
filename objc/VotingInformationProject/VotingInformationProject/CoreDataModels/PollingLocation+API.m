//
//  PollingLocation+API.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/3/14.
//  
//

#import "PollingLocation+API.h"
#import "Election+API.h"

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
    [pollingLocation updateFromDictionary:mutableAttributes];

    pollingLocation.address = (VIPAddress*)[VIPAddress setFromDictionary:address];

    for (NSDictionary *dataSource in dataSources) {
        [pollingLocation addDataSourcesObject:(DataSource*)[DataSource setFromDictionary:dataSource]];
    }

    return pollingLocation;
}

- (BOOL)isAvailable
{
    NSDateFormatter *yyyymmddFormatter = [Election getElectionDateFormatter];
    NSDate *startDate = [yyyymmddFormatter dateFromString:self.startDate];
    NSDate *endDate = [yyyymmddFormatter dateFromString:self.endDate];
    // Assume valid if either of these are missing as per the VIP Spec 3.0
    if (!startDate || !endDate) {
        return YES;
    }

    NSDate *today = [Election today];
    // Check if today is before PollingLocation endDate
    if ([today compare:endDate] == NSOrderedAscending) {
        return YES;
    } else {
        return NO;
    }
}


@end
