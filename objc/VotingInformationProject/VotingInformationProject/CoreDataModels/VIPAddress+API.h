//
//  VIPAddress+API.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/5/14.
//  
//

#import "VIPAddress.h"

#import <CoreLocation/CoreLocation.h>
#import "VIPError.h"

@interface VIPAddress (API)

+ (VIPAddress*)setFromDictionary:(NSDictionary*)attributes;

- (NSString*)toABAddressString:(BOOL)withNewlines;

@end
