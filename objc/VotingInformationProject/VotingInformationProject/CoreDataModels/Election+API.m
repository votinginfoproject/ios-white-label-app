//
//  Election+API.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 6/24/14.
//

#import "Election+API.h"
#import "AppSettings.h"
#import "AFNetworking/AFNetworking.h"
#import "VIPError.h"

@implementation Election (API)

- (NSString *) getDateString
{
    NSString *electionDateString = nil;
    if (self.electionDay) {
        NSDateFormatter *yyyymmddFormatter = [[NSDateFormatter alloc] init];
        [yyyymmddFormatter setDateStyle:NSDateFormatterMediumStyle];
        [yyyymmddFormatter setTimeStyle:NSDateFormatterNoStyle];
        electionDateString = [yyyymmddFormatter stringFromDate:self.electionDay];
    }
    return electionDateString;
}

+ (NSDateFormatter*)getElectionDateFormatter
{
    // setup date formatter
    static dispatch_once_t onceToken;
    static NSDateFormatter *yyyymmddFormatter = nil;
    dispatch_once(&onceToken, ^{
        yyyymmddFormatter = [[NSDateFormatter alloc] init];
        [yyyymmddFormatter setDateFormat:@"yyyy-MM-dd"];
    });
    return yyyymmddFormatter;
}

+ (NSDate*)today
{
    NSCalendarUnit units = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents* comps = [[NSCalendar currentCalendar] components:units fromDate:[NSDate date]];
    comps.day = comps.day - 1;
    return [[NSCalendar currentCalendar] dateFromComponents:comps];
}

@end
