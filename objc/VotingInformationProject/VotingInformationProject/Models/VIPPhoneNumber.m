//
//  VIPPhoneNumber.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 9/30/14.
//

#import "VIPPhoneNumber.h"

#import "NBPhoneNumberUtil.h"

@implementation VIPPhoneNumber

NSString * const DEFAULT_COUNTRY_CODE = @"US";

+ (NSURL*)makeTelPromptLink:(NSString *)phone
{
    NBPhoneNumberUtil *phoneUtil = [NBPhoneNumberUtil sharedInstance];
    NSError *phoneError = nil;
    NBPhoneNumber *nbPhoneNumber = [phoneUtil parse:phone
                                      defaultRegion:DEFAULT_COUNTRY_CODE
                                              error:&phoneError];
    if (phoneError) {
        NSLog(@"VIPPhoneNumber %@: ERROR %@", phone, phoneError.localizedDescription);
        return nil;
    }
    NSString *phoneNumber = [phoneUtil formatNumberForMobileDialing:nbPhoneNumber
                                                  regionCallingFrom:DEFAULT_COUNTRY_CODE
                                                     withFormatting:NO
                                                              error:&phoneError];
    NSString *phonePrompt = [NSString stringWithFormat:@"telprompt:%@", phoneNumber];
    return [NSURL URLWithString:phonePrompt];
}

@end
