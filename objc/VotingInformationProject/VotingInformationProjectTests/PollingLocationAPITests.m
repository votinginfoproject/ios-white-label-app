//
//  CoreDataModelTests.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/3/14.
//

#import <XCTest/XCTest.h>
#import "Kiwi.h"

#import "PollingLocation+API.h"
#import "Election+API.h"

SPEC_BEGIN(PollingLocationAPITests)

describe(@"PLAPITests", ^{
    
    beforeEach(^{
        [MagicalRecord setupCoreDataStackWithInMemoryStore];
    });
    
    afterEach(^{
        [MagicalRecord cleanUp];
    });

    it(@"should ensure that setDictionary sets empty objects with nil", ^{

        NSDictionary *attributes = @{};
        PollingLocation *pl = [PollingLocation setFromDictionary:attributes asEarlyVotingSite:YES];

        [[pl.isEarlyVoteSite should] beYes];
        [[pl.address shouldNot] beNil];
        [[pl.address.locationName should] beNil];
        [[theValue([pl.dataSources count]) should] equal:theValue(0)];
    });

    it(@"should ensure that setDictionary sets valid keys of PollingLocation", ^{

        NSString *notesvalue = @"blanknotes";
        NSString *namevalue = @"site 1";
        NSDictionary *attributes = @{
                                     @"notes": notesvalue,
                                     @"name": namevalue,
                                     @"address": @{@"locationName": @"123 Test Drive"},
                                     @"sources": @[@{@"name": @"Test DataSource"}]
                                     };

        PollingLocation *pl = [PollingLocation setFromDictionary:attributes asEarlyVotingSite:NO];
        [[pl.isEarlyVoteSite should] beNo];
        [[theValue([pl.dataSources count]) should] equal:theValue(1)];
        [[pl.address.locationName should] equal:@"123 Test Drive"];
        [[pl.notes should] equal:notesvalue];
        [[pl.name should] equal:namevalue];
    });

    it(@"should ensure that isAvailable returns YES if startDate or endDate are nil", ^{
        NSDate *now = [NSDate date];
        int daysPast = 3;
        int daysFuture = 3;
        NSDate *startDate = [now dateByAddingTimeInterval:-1*60*60*24*daysPast];
        NSDate *endDate = [now dateByAddingTimeInterval:60*60*24*daysFuture];
        NSDateFormatter *yyyymmddFormatter = [[NSDateFormatter alloc] init];
        [yyyymmddFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *endDateString = [yyyymmddFormatter stringFromDate:endDate];
        NSString *startDateString = [yyyymmddFormatter stringFromDate:startDate];

        NSString *notesvalue = @"blanknotes";
        NSString *namevalue = @"site 1";
        NSDictionary *attributes = @{
                                     @"notes": notesvalue,
                                     @"name": namevalue,
                                     @"address": @{@"locationName": @"123 Test Drive"},
                                     @"sources": @[@{@"name": @"Test DataSource"}],
                                     @"startDate": [NSNull null],
                                     @"endDate": endDateString,
                                     @"isEarlyVoteSite": @(YES)
                                     };

        PollingLocation *pl = [PollingLocation setFromDictionary:attributes asEarlyVotingSite:YES];
        [[theValue([pl isAvailable]) should] equal:theValue(YES)];
        pl.startDate = startDateString;
        pl.endDate = nil;
        [[theValue([pl isAvailable]) should] equal:theValue(YES)];
    });

    it(@"should ensure that isAvailable returns NO if today is after endDate", ^{
        NSDate *now = [NSDate date];
        int daysPast = 8;
        int daysFuture = -3;
        NSDate *startDate = [now dateByAddingTimeInterval:-1*60*60*24*daysPast];
        NSDate *endDate = [now dateByAddingTimeInterval:60*60*24*daysFuture];
        NSDateFormatter *yyyymmddFormatter = [[NSDateFormatter alloc] init];
        [yyyymmddFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *endDateString = [yyyymmddFormatter stringFromDate:endDate];
        NSString *startDateString = [yyyymmddFormatter stringFromDate:startDate];

        NSString *notesvalue = @"blanknotes";
        NSString *namevalue = @"site 1";
        NSDictionary *attributes = @{
                                     @"notes": notesvalue,
                                     @"name": namevalue,
                                     @"address": @{@"locationName": @"123 Test Drive"},
                                     @"sources": @[@{@"name": @"Test DataSource"}],
                                     @"startDate": startDateString,
                                     @"endDate": endDateString,
                                     @"isEarlyVoteSite": @(YES)
                                     };

        PollingLocation *pl = [PollingLocation setFromDictionary:attributes asEarlyVotingSite:YES];
        [[theValue([pl isAvailable]) should] equal:theValue(NO)];
        // Shouldnt matter if earlyVoteSite or not
        pl.isEarlyVoteSite = NO;
        [[theValue([pl isAvailable]) should] equal:theValue(NO)];
    });

    it(@"should ensure that isAvailable returns YES if today is before endDate", ^{
        NSDate *now = [NSDate date];
        int daysPast = -3;
        int daysFuture = 8;
        NSDate *startDate = [now dateByAddingTimeInterval:-1*60*60*24*daysPast];
        NSDate *endDate = [now dateByAddingTimeInterval:60*60*24*daysFuture];
        NSDateFormatter *yyyymmddFormatter = [[NSDateFormatter alloc] init];
        [yyyymmddFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *endDateString = [yyyymmddFormatter stringFromDate:endDate];
        NSString *startDateString = [yyyymmddFormatter stringFromDate:startDate];

        NSString *notesvalue = @"blanknotes";
        NSString *namevalue = @"site 1";
        NSDictionary *attributes = @{
                                     @"notes": notesvalue,
                                     @"name": namevalue,
                                     @"address": @{@"locationName": @"123 Test Drive"},
                                     @"sources": @[@{@"name": @"Test DataSource"}],
                                     @"startDate": startDateString,
                                     @"endDate": endDateString,
                                     @"isEarlyVoteSite": @(YES)
                                     };

        PollingLocation *pl = [PollingLocation setFromDictionary:attributes asEarlyVotingSite:YES];
        [[theValue([pl isAvailable]) should] equal:theValue(YES)];
        // Shouldnt matter if earlyVoteSite or not
        pl.isEarlyVoteSite = NO;
        [[theValue([pl isAvailable]) should] equal:theValue(YES)];
    });

});

SPEC_END
