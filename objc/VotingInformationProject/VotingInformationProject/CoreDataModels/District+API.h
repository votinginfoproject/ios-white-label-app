//
//  District+API.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/6/14.
//  Copyright (c) 2014 Bennet Huber. All rights reserved.
//

#import "District.h"

@interface District (API)

+ (District *) setFromDictionary:(NSDictionary*)attributes;

@end
