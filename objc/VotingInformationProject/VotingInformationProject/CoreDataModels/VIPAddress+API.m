//
//  VIPAddress+API.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/5/14.
//  
//

#import <AddressBookUI/AddressBookUI.h>
#import <AddressBook/AddressBook.h>
#import "VIPAddress+API.h"

@implementation VIPAddress (API)

- (NSString*)toABAddressString:(BOOL)withNewlines
{
    // TODO: Allow user to set country code in settings.plist
    //NSString *street = [NSString stringWithFormat:@"%@ %@ %@", self.line1, self.line2, self.line3];
    NSDictionary *addressDict = @{
                                  (NSString*)kABPersonAddressStreetKey: self.line1,
                                  (NSString*)kABPersonAddressCityKey: self.city,
                                  (NSString*)kABPersonAddressStateKey: self.state,
                                  (NSString*)kABPersonAddressZIPKey: self.zip,
                                  (NSString*)kABPersonAddressCountryCodeKey: @"us"};
    NSString *address = ABCreateStringWithAddressDictionary(addressDict, YES);
    if (!withNewlines) {
        address = [address stringByReplacingOccurrencesOfString:@"\n" withString:@", "];
    }
    return address;
}

@end
