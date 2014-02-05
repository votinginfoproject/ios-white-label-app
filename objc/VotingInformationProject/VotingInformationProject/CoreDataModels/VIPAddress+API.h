//
//  VIPAddress+API.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/5/14.
//  Copyright (c) 2014 Bennet Huber. All rights reserved.
//

#import "VIPAddress.h"

@interface VIPAddress (API)

/*
 * keys in NSDictionary address should be the same as the 
 * properties of this class
 */
+ (VIPAddress*) createWith:(NSDictionary*)address;

@end
