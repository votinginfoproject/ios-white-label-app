//
//  State+API.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/5/14.
//  
//

#import "State+API.h"
#import "CoreData+MagicalRecord.h"

@implementation State (API)

+ (State*) setFromDictionary:(NSDictionary *)attributes
{
    NSMutableDictionary *mutableAttributes = [attributes mutableCopy];

    NSString *eabKey = @"electionAdministrationBody";
    NSDictionary *eabDictionary = attributes[eabKey];
    [mutableAttributes removeObjectForKey:eabKey];

    NSString *dataSourcesKey = @"sources";
    NSArray *dataSourcesArray = attributes[dataSourcesKey];
    [mutableAttributes removeObjectForKey:dataSourcesKey];

    // TODO: Add this key back later and make model if necessary
    NSString *localJurisdictionKey = @"local_jurisdiction";
    NSMutableDictionary *localJurisidiction = attributes[localJurisdictionKey];
    [mutableAttributes removeObjectForKey:localJurisdictionKey];

    State *state = [State MR_createEntity];

    // Set State Attributes
    [state updateFromDictionary:mutableAttributes];

    // Set EAB
    state.electionAdministrationBody = [ElectionAdministrationBody setFromDictionary:eabDictionary];

    // Set DataSources
    for (NSDictionary *dataSource in dataSourcesArray) {
        [state addDataSourcesObject:(DataSource*)[DataSource setFromDictionary:dataSource]];
    }

    // Set LocalJurisdiction, only if exists
    if ([localJurisidiction count] > 0) {
        state.localJurisdiction = [State setFromDictionary:localJurisidiction];
    }

    return state;
}

@end
