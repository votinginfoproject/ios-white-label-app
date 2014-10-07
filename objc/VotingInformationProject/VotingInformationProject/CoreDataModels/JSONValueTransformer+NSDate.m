//
//  JSONValueTransformer+NSDate.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 10/7/14.
//

#import "JSONValueTransformer+NSDate.h"

#import "Election+API.h"

@implementation JSONValueTransformer (NSDate)

- (id)NSDateFromNSString:(NSString*)string
{
    NSDateFormatter *yyyymmddFormatter = [Election getElectionDateFormatter];
    return [yyyymmddFormatter dateFromString:string];
}

// Return string of format yyyy-MM-dd
- (id)JSONObjectFromNSDate:(NSDate*)nsdate
{
    if (!nsdate) {
        return @"";
    }
    NSDateFormatter *yyyymmddFormatter = [Election getElectionDateFormatter];
    return [yyyymmddFormatter stringFromDate:nsdate];
}

@end
