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
    Election *election = nil;
    if (electionId && [electionId length] > 0) {
        election = [Election MR_findFirstByAttribute:@"electionId" withValue:electionId];
        if (!election) {
            election = [Election MR_createEntity];
            election.electionId = electionId;
#if DEBUG
            NSLog(@"Created new election with id: %@", electionId);
#endif
        } else {
#if DEBUG
            NSLog(@"Retrieved election %@ from data store", electionId);
#endif
        }
    }
    return election;
}

@end
