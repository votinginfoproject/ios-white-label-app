//
//  UserAddress+API.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/3/14.
//  Copyright (c) 2014 Bennet Huber. All rights reserved.
//

#import "UserAddress.h"

@interface UserAddress (API)

// UNIQUE: UserAddress.address
+ (UserAddress*)getUnique:(NSString *)address;

@end
