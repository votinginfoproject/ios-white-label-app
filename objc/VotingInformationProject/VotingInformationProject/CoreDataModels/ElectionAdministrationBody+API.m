//
//  ElectionAdministrationBody+API.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/5/14.
//  
//

#import "ElectionAdministrationBody+API.h"

@implementation ElectionAdministrationBody (API)

+ (NSDictionary*)propertyList
{
    static NSDictionary *propertyList = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        propertyList = @{
                         @"name": NSLocalizedString(@"Name", @"Label for election administration body's name"),
                         @"hoursOfOperation": NSLocalizedString(@"Hours", @"Label for election administration body's hours of operation"),
                         @"voterServices": NSLocalizedString(@"Voter Services", @"Label for election administration body's voter services"),
                         @"electionInfoUrl": NSLocalizedString(@"Election Info", @"Label for election adnimistration body's information link"),
                         @"electionRegistrationUrl": NSLocalizedString(@"Election Registration", @"Label for election administration body's registration information link"),
                         @"electionRegistrationConfirmationUrl": NSLocalizedString(@"Election Registration Confirmation", @"Label for election administration body's registration confirmation link"),
                         @"absenteeVotingInfoUrl": NSLocalizedString(@"Absentee Info", @"Label for election administration body's absentee voting information link"),
                         @"votingLocationFinderUrl": NSLocalizedString(@"Voting Location Finder", @"Label for voting location finder information link"),
                         @"ballotInfoUrl": NSLocalizedString(@"Ballot Info", @"Label for ballot information link"),
                         @"electionRulesUrl": NSLocalizedString(@"Election Rules", @"Label for election administration body's election rules link")
                         };
    });
    return propertyList;
}

@end
