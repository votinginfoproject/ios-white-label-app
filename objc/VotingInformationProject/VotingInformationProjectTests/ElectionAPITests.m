//
//  ElectionAPITests.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/5/14.
//

#import <XCTest/XCTest.h>
#import "Kiwi.h"

#import "UserElection+API.h"
#import "UserAddress+API.h"
#import "Contest.h"
#import "State.h"
#import "PollingLocation+API.h"

SPEC_BEGIN(ElectionAPITests)

describe(@"Election+API Tests", ^{

    beforeEach(^{
        [MagicalRecord setupCoreDataStackWithInMemoryStore];
    });

    afterEach(^{
        [MagicalRecord cleanUp];
    });

    it(@"should ensure that getUnique returns a new election with electionId and userAddress set", ^{
        UserAddress *userAddress = [UserAddress getUnique:@"123 Test Drive"];
        UserElection *election1 = [UserElection getUnique:@"election1" withUserAddress:userAddress];
        [[election1.userAddress should] equal:userAddress];
        [[election1.electionId should] equal:@"election1"];
    });

    it(@"should ensure that getUnique returns a new election with lastUpdated not set", ^{
        UserAddress *userAddress = [UserAddress getUnique:@"123 Test Drive"];
        UserElection *election1 = [UserElection getUnique:@"election1" withUserAddress:userAddress];
        [election1.lastUpdated shouldBeNil];
    });

    it(@"should ensure that shouldUpdate returns YES after creating a new election", ^{
        UserAddress *userAddress = [UserAddress getUnique:@"123 Test Drive"];
        UserElection *election1 = [UserElection getUnique:@"election1" withUserAddress:userAddress];
        [[theValue([election1 shouldUpdate]) should] equal:theValue(YES)];
    });

    it(@"should ensure that shouldUpdate returns YES after setting lastUpdated but still no data", ^{
        UserAddress *userAddress = [UserAddress getUnique:@"123 Test Drive"];
        UserElection *election1 = [UserElection getUnique:@"election1" withUserAddress:userAddress];
        election1.lastUpdated = [NSDate date];
        [[theValue([election1 shouldUpdate]) should] equal:theValue(YES)];
    });

    it(@"should ensure that shouldUpdate returns NO after setting lastUpdated to now and at least one data point", ^{
        UserAddress *userAddress = [UserAddress getUnique:@"123 Test Drive"];
        UserElection *election1 = [UserElection getUnique:@"election1" withUserAddress:userAddress];
        election1.lastUpdated = [NSDate date];
        Contest *contest1 = [Contest MR_createEntity];
        [election1 addContestsObject:contest1];

        // This line fails if your settings.plist VotingInfoCacheDays is set to < 1
        [[theValue([election1 shouldUpdate]) should] equal:theValue(NO)];
    });

    it(@"should ensure that filterPollingLocations returns only isEarlyVoteSite", ^{
        PollingLocation *pl1 = [PollingLocation MR_createEntity];
        pl1.name = @"pl1";
        pl1.isEarlyVoteSite = @(YES);
        PollingLocation *pl2 = [PollingLocation MR_createEntity];
        pl2.name = @"pl2";
        pl2.isEarlyVoteSite = @(YES);
        PollingLocation *pl3 = [PollingLocation MR_createEntity];
        pl3.name = @"pl3";
        pl3.isEarlyVoteSite = @(NO);
        UserElection *election = [UserElection MR_createEntity];
        NSSet *locations = [NSSet setWithObjects:pl1, pl2, pl3,nil];
        [election addPollingLocations:locations];

        NSArray *allSites = [election filterPollingLocations:VIPPollingLocationTypeAll];
        [[theValue([allSites count]) should] equal:theValue(3)];

        NSArray *earlyVoteSites = [election filterPollingLocations:VIPPollingLocationTypeEarlyVote];
        [[theValue([earlyVoteSites count]) should] equal:theValue(2)];

        NSArray *normalSites = [election filterPollingLocations:VIPPollingLocationTypeNormal];
        [[theValue([normalSites count]) should] equal:theValue(1)];
        PollingLocation *site3 = normalSites[0];
        [[site3.name should] equal:@"pl3"];

    });

    it(@"should ensure that deleteAllData deletes all contests from the election", ^{
        UserElection *election1 = [UserElection MR_createEntity];
        Contest *contest1 = [Contest MR_createEntity];
        Contest *contest2 = [Contest MR_createEntity];
        [election1 addContestsObject:contest1];
        [election1 addContestsObject:contest2];
        [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *context) {}];
        [[theValue([election1.contests count]) should] equal:theValue(2)];
        [election1 deleteAllData];
        [[theValue([election1.contests count]) should] equal:theValue(0)];
        [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *context) {}];
    });

    it(@"should ensure that deleteAllData deletes all states from the election", ^{
        UserElection *election1 = [UserElection MR_createEntity];
        State *state1 = [State MR_createEntity];
        State *state2 = [State MR_createEntity];
        [election1 addStatesObject:state1];
        [election1 addStatesObject:state2];
        [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *context) {}];
        [[theValue([election1.states count]) should] equal:theValue(2)];
        [election1 deleteAllData];
        [[theValue([election1.states count]) should] equal:theValue(0)];
        [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *context) {}];
    });

    it(@"should ensure that deleteAllData deletes all pollinglocations from the election", ^{
        UserElection *election1 = [UserElection MR_createEntity];
        PollingLocation *pl1 = [PollingLocation MR_createEntity];
        PollingLocation *pl2 = [PollingLocation MR_createEntity];
        [election1 addPollingLocationsObject:pl1];
        [election1 addPollingLocationsObject:pl2];
        [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *context) {}];
        [[theValue([election1.pollingLocations count]) should] equal:theValue(2)];
        [election1 deleteAllData];
        [[theValue([election1.pollingLocations count]) should] equal:theValue(0)];
        [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *context) {}];
    });

    it(@"should ensure that setDateFromString properly sets election date", ^{
        UserElection *election = [UserElection MR_createEntity];
        NSString *testDateString = @"2013-01-01";
        NSString *formattedTestDateString = @"Jan 1, 2013";
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy-MM-dd"];
        NSDate *testDate = [df dateFromString:testDateString];

        [election setDateFromString:testDateString];
        [[testDate should] equal:election.date];
        [[formattedTestDateString should] equal:[election getDateString]];
    });

    it(@"getVoterInfoAt test ", ^{
        [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *context) {}];
    });

    it(@"parseVoterInfoJSON test ", ^{
        [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *context) {}];
    });
});

SPEC_END
