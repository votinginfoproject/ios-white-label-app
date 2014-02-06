//
//  Candidate+API.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/6/14.
//  Copyright (c) 2014 Bennet Huber. All rights reserved.
//

#import "Candidate.h"

@interface Candidate (API)

+ (Candidate*) setFromDictionary:(NSDictionary*)attributes;

@end
