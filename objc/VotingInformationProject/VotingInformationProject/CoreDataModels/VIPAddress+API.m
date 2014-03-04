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

+ (VIPAddress*)setFromDictionary:(NSDictionary *)attributes
{
    VIPAddress *vipAddress = [self MR_createEntity];
    [vipAddress setValuesForKeysWithDictionary:attributes];
    vipAddress.address = [vipAddress toABAddressString:YES];
    return vipAddress;
}

- (NSString*)toABAddressString:(BOOL)withNewlines
{
    // TODO: Allow user to set country code in settings.plist
    //NSString *street = [NSString stringWithFormat:@"%@ %@ %@", self.line1, self.line2, self.line3];
    NSString *line1 = self.line1 ? self.line1 : @"";
    NSString *city = self.city ? self.city : @"";
    NSString *state = self.state ? self.state : @"";
    NSString *zip = self.zip ? self.zip : @"";
    NSDictionary *addressDict = @{
                                  (NSString*)kABPersonAddressStreetKey: line1,
                                  (NSString*)kABPersonAddressCityKey: city,
                                  (NSString*)kABPersonAddressStateKey: state,
                                  (NSString*)kABPersonAddressZIPKey: zip,
                                  (NSString*)kABPersonAddressCountryCodeKey: @"us"};
    NSString *address = ABCreateStringWithAddressDictionary(addressDict, YES);
    if (!withNewlines) {
        address = [address stringByReplacingOccurrencesOfString:@"\n" withString:@", "];
    }
    return address;
}

@end
