//
//  Election+API.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 1/31/14.
//  Copyright (c) 2014 Bennet Huber. All rights reserved.
//

#import "Election+API.h"

@implementation Election (API)

+ (Election*) getOrCreate:(NSString*)electionId {
    Election *election;
    if (electionId) {
        election = [Election MR_findFirstByAttribute:@"electionId" withValue:electionId];
        if (!election) {
            election = [Election MR_createEntity];
            election.electionId = electionId;
            NSLog(@"Created new election with id: %@", electionId);
        } else {
            NSLog(@"Retrieved election %@ from data store", electionId);
        }
    }
    return election;
}

@end
