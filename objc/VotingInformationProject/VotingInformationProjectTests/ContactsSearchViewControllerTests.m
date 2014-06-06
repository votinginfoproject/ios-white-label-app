//
//  ContactsSearchViewControllerTests.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 1/23/14.
//

#import <XCTest/XCTest.h>
#import <AddressBook/AddressBook.h>
#import "Kiwi.h"
#import "ContactsSearchViewController.h"

SPEC_BEGIN(ContactsSearchViewControllerTests)

describe(@"ContactsSearchViewController", ^{
    it(@"should return string address formatted using ABCreateStringWithAddressDictionary", ^{
        CFErrorRef error = NULL;
        ABRecordRef contact = ABPersonCreate();
        BOOL didSet;

        NSString * street = @"123 Test Drive";
        NSString *city = @"AnyTown";
        NSString *state = @"PA";
        NSString *zip = @"19107";
        NSString *country = @"United States";

        ABMultiValueIdentifier multiValueId;
        ABMutableMultiValueRef multi = ABMultiValueCreateMutable(kABMultiDictionaryPropertyType);
        NSMutableDictionary *address1 = [[NSMutableDictionary alloc] init];
        [address1 setObject:street forKey:(NSString *) kABPersonAddressStreetKey];
        [address1 setObject:city forKey:(NSString *) kABPersonAddressCityKey];
        [address1 setObject:state forKey:(NSString *) kABPersonAddressStateKey];
        [address1 setObject:zip forKey:(NSString *) kABPersonAddressZIPKey];
        [address1 setObject:country forKey:(NSString *) kABPersonAddressCountryKey];
        didSet = ABMultiValueAddValueAndLabel(multi, CFBridgingRetain(address1), kABWorkLabel, &multiValueId);

        didSet = ABRecordSetValue(contact, kABPersonAddressProperty, multi, &error);

        NSString *address = nil;
        if (error)
        {
            CFStringRef errorDesc = CFErrorCopyDescription(error);
            NSLog(@"Contact not saved: %@", errorDesc);
            CFRelease(errorDesc);
            [address shouldNotBeNil];
        } else {
            id testController = [[ContactsSearchViewController alloc] init];
            address = [testController getAddress:contact atIdentifier:multiValueId];
            NSLog(@"%@", address);
            [[address should] equal:ABCreateStringWithAddressDictionary(address1, NO)];
        }
        CFRelease(multi);
        CFRelease(contact);

    });
});

SPEC_END
