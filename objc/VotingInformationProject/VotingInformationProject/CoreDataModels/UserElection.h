//
//  UserElection.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 6/24/14.
//

#import "JSONModel.h"
#import "Contest.h"
#import "EarlyVoteSite.h"
#import "Election.h"
#import "PollingLocation.h"
#import "State.h"


@interface UserElection : JSONModel

@property (nonatomic, strong) NSString *kind;
@property (nonatomic, strong) VIPAddress *normalizedInput;
@property (nonatomic, strong) Election *election;
@property (nonatomic, strong) NSArray<Election, Optional> *otherElections;
@property (nonatomic, strong) NSArray<Contest, Optional> *contests;
@property (nonatomic, strong) NSArray<PollingLocation, Optional> *pollingLocations;
@property (nonatomic, strong) NSArray<EarlyVoteSite, Optional> *earlyVoteSites;
@property (nonatomic, strong) NSArray<State, Optional> *state;

@end
