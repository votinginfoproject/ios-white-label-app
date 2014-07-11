//
//  ElectionAdministrationBody+API.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/5/14.
//  
//

#import "ElectionAdministrationBody+API.h"
#import "State+API.h"

@implementation ElectionAdministrationBody (API)

+ (ElectionAdministrationBody*) setFromDictionary:(NSDictionary *)attributes
{
    NSMutableDictionary *mutableAttributes = [attributes mutableCopy];

    NSString *officialsKey = @"electionOfficials";
    NSArray *officials = attributes[officialsKey];
    [mutableAttributes removeObjectForKey:officialsKey];

    NSString *mailingAddressKey = @"correspondenceAddress";
    NSDictionary *mailingAddressDict = attributes[mailingAddressKey];
    [mutableAttributes removeObjectForKey:mailingAddressKey];

    NSString *physicalAddressKey = @"physicalAddress";
    NSDictionary *physicalAddressDict = attributes[physicalAddressKey];
    [mutableAttributes removeObjectForKey:physicalAddressKey];

    ElectionAdministrationBody *eab = [ElectionAdministrationBody MR_createEntity];
    // Set attributes
    [eab updateFromDictionary:mutableAttributes];

    // Set addresses
    if (mailingAddressDict) {
        [eab addAddressesObject:(VIPAddress*)[VIPAddress setFromDictionary:mailingAddressDict]];
    }
    if (physicalAddressDict) {
        [eab addAddressesObject:(VIPAddress*)[VIPAddress setFromDictionary:physicalAddressDict]];
    }

    // Set Election officials
    for (NSDictionary *official in officials) {
        [eab addElectionOfficialsObject:(ElectionOfficial*)[ElectionOfficial setFromDictionary:official]];
    }

    return eab;
}

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

- (NSMutableArray*)getProperties
{
    NSMutableArray *properties = [super getProperties];

    // Need to add state.name first in the returned object so it is consistently at the same spot
    NSString *localizedStateTitle = NSLocalizedString(@"State", @"Label for election administration body's state");
    NSDictionary *stateName = @{@"title": localizedStateTitle, @"data": self.state.name};
    [properties insertObject:stateName atIndex:0];
    return properties;
}

@end
