//
//  UserElection+API.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 1/31/14.
//  
//

#import "UserElection+API.h"
#import "AppSettings.h"

@implementation UserElection (API)

- (NSArray*)getUniqueParties
{
    NSMutableDictionary *parties = [NSMutableDictionary dictionary];
    for (Contest *contest in self.contests) {
        NSString *party = contest.primaryParty;
        if ([party length] > 0) {
            parties[party] = party;
        }
    }
    // Sort alphabetically to avoid appearing partisan by certain parties appearing first
    return [[parties allValues] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
}

- (NSArray*)filterPollingLocations:(VIPPollingLocationType)type
{
    if (type == VIPPollingLocationTypeAll) {
        return [[self.pollingLocations
                 arrayByAddingObjectsFromArray:self.earlyVoteSites]
                 arrayByAddingObjectsFromArray:self.dropOffLocations];
    } else if (type == VIPPollingLocationTypeNormal) {
        return self.pollingLocations;
    } else if (type == VIPPollingLocationTypeEarlyVote) {
        return self.earlyVoteSites;
    } else if (type == VIPPollingLocationTypeDropoff) {
        return self.dropOffLocations;
    } else {
        return @[];
    }
}

@end
