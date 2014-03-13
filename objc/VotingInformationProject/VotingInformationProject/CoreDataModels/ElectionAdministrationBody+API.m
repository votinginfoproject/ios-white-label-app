//
//  ElectionAdministrationBody+API.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/5/14.
//  
//

#import "ElectionAdministrationBody+API.h"

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

@end
