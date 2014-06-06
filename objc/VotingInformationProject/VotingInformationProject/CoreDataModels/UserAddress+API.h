//
//  UserAddress+API.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/3/14.
//  
//

#import "UserAddress.h"

@interface UserAddress (API)

// UNIQUE: UserAddress.address
+ (UserAddress*)getUnique:(NSString *)address;

- (BOOL) hasAddress;

@end
