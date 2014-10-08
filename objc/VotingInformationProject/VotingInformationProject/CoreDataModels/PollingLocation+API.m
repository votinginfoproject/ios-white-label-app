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

- (BOOL)isAvailable
{
    // Assume valid if either of these are missing as per the VIP Spec 3.0
    if (!self.startDate || !self.endDate) {
        return YES;
    }

    NSDate *today = [Election today];
    // Check if today is before PollingLocation endDate
    if ([today compare:self.endDate] == NSOrderedAscending) {
        return YES;
    } else {
        return NO;
    }
}


@end
