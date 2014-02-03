//
//  Election+API.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 1/31/14.
//  Copyright (c) 2014 Bennet Huber. All rights reserved.
//

#import "Election.h"

@interface Election (API)

+ (Election *) getOrCreate:(NSString*)electionId;

@end
