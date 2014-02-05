//
//  ElectionOfficial+API.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/5/14.
//  Copyright (c) 2014 Bennet Huber. All rights reserved.
//

#import "ElectionOfficial.h"

@interface ElectionOfficial (API)

+ (ElectionOfficial*) setFromDictionary:(NSDictionary*)attributes;

@end
