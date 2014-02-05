//
//  ElectionAdministrationBody+API.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/5/14.
//  Copyright (c) 2014 Bennet Huber. All rights reserved.
//

#import "ElectionAdministrationBody+API.h"

@implementation ElectionAdministrationBody (API)

+ (ElectionAdministrationBody*) setFromDictionary:(NSDictionary *)attributes
                                    withAddresses:(NSArray *)addresses
                            withElectionOfficials:(NSArray *)officials
{
    ElectionAdministrationBody *eab = [ElectionAdministrationBody MR_createEntity];
    [eab setValuesForKeysWithDictionary:attributes];

    for (NSDictionary *address in addresses) {
        [eab addAddressesObject:[VIPAddress createWith:address]];
    }

    for (NSDictionary *official in officials) {
        ElectionOfficial *electionOfficial = [ElectionOfficial MR_createEntity];
        [electionOfficial setValuesForKeysWithDictionary:official];
        [eab addElectionOfficialsObject:electionOfficial];
    }

    return eab;
}

@end
