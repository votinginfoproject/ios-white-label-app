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
                         @"absenteeVotingInfoUrl": NSLocalizedString(@"Absentee Info", @"Label for election administration body's absentee voting information link"),
                         @"electionRegistrationUrl": NSLocalizedString(@"Election Registration", @"Label for election administration body's registration information link"),
                         @"electionRulesUrl": NSLocalizedString(@"Election Rules", @"Label for election administration body's election rules link")
                         };
    });
    return propertyList;
}

@end
