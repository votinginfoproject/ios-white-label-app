//
//  VIPManagedObjectTests.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/6/14.
//

#import <XCTest/XCTest.h>
#import "Kiwi.h"

#import "VIPManagedObject.h"
#import "VIPAddress+API.h"
#import "Contest+API.h"
#import "DataSource+API.h"

SPEC_BEGIN(VIPManagedObjectTests)

/**
 Helper function to create a contest with two candidates
 */
Contest* (^createMockContest) () = ^Contest* () {
    Contest* contest = [Contest MR_createEntity];
    contest.id = @"Lord of Winterfell";
    Candidate* candidate = [Candidate MR_createEntity];
    Candidate* candidate2 = [Candidate MR_createEntity];
    candidate.name = @"Jon Snow";
    candidate2.name = @"Bran Stark";
    [contest addCandidatesObject:candidate];
    [contest addCandidatesObject:candidate2];
    return contest;
};

describe(@"VIPManagedObjectTests", ^{
    
    beforeEach(^{
        [MagicalRecord setupCoreDataStackWithInMemoryStore];
    });
    
    afterEach(^{
        [MagicalRecord cleanUp];
    });

    it(@"should ensure that setFromDictionary does not crash if invalid keys are passed", ^{
        // Cannot instantiate an abstract entity, so test the subclasses...
        NSString *validName = @"But this is a real key...";
        NSDictionary *attributes = @{@"IMANINVALIDKEYARGGHHH": @"No way is this a real key",
                                     @"name": validName,
                                     @"primaryParty": validName,
                                     @"locationName": validName};


        VIPAddress *vipAddress = (VIPAddress*)[VIPAddress setFromDictionary:attributes];
        [[vipAddress.locationName should] equal:validName];

        Contest *contest = (Contest*)[Contest setFromDictionary:attributes];
        [[contest.primaryParty should] equal:validName];

        DataSource *ds = (DataSource*)[DataSource setFromDictionary:attributes];
        [[ds.name should] equal:validName];
    });

    it(@"should ensure that getSorted:byProperty:ascending returns results", ^{
        Contest* contest = createMockContest();
        NSArray* candidates = [contest getSorted:@"candidates"
                                      byProperty:@"name"
                                       ascending:YES];
        Candidate* bran = candidates[0];
        [[bran.name should] equal:@"Bran Stark"];
        [[theValue([candidates count]) should] equal:theValue(2)];

        // sort again to force the sort to actually happen
        candidates = [contest getSorted:@"candidates"
                                      byProperty:@"name"
                                       ascending:NO];
        Candidate* jon = candidates[0];
        [[jon.name should] equal:@"Jon Snow"];
    });
    
    it(@"should ensure that getSorted returns empty array with bad input", ^{
        Contest* contest = createMockContest();
        NSArray* candidatesBadProperty = [contest getSorted:@"badProperty"
                                                 byProperty:@"name"
                                                  ascending:NO];
        [[candidatesBadProperty should] equal:@[]];
    });
});

SPEC_END

