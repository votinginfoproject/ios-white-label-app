//
//  VIPAddress+API.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/5/14.
//  
//

#import "VIPAddress.h"

@interface VIPAddress (API)

- (NSString*)toABAddressString:(BOOL)withNewlines;

@end
