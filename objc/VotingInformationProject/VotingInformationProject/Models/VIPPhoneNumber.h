//
//  VIPPhoneNumber.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 9/30/14.
//

#import <Foundation/Foundation.h>

@interface VIPPhoneNumber : NSObject

+ (NSURL*)makeTelPromptLink:(NSString*)phone;

extern NSString * const DEFAULT_COUNTRY_CODE;

@end
