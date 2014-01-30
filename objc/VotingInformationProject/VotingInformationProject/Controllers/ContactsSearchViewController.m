//
//  ContactsSearchViewController.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 1/22/14.
//  Copyright (c) 2014 Bennet Huber. All rights reserved.
//
// Great project that quickly seeds the iOS Simulator with Contacts:
//  https://github.com/cristianbica/CBSimulatorSeed

#import "VIPUserDefaultsKeys.h"
#import "ContactsSearchViewController.h"

@interface ContactsSearchViewController ()

@property (weak, nonatomic) IBOutlet UIButton *showPeoplePicker;
@property (weak, nonatomic) IBOutlet UILabel *selectedAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *localizationLabel;

@end

@implementation ContactsSearchViewController

NSUserDefaults* _userDefaults;

- (void)viewDidLoad
{
    [super viewDidLoad];
    _userDefaults = [NSUserDefaults standardUserDefaults];
   
    NSString *storedAddress = [_userDefaults objectForKey:USER_DEFAULTS_STORED_ADDRESS];
    if (storedAddress) {
        self.selectedAddressLabel.text = storedAddress;
    }

    /* i18n Sample Demo
     Use number formatter/date formatter/etc for numbers, dates, etc. Controlled by:
        Settings.app->General->International->Region Format
     Control language settings via:
        Settings.app->General->International->Language
     
    Second argument to NSLocalizedString is a comment to be provided in the Localizable.strings file
        for translator context
    
    genstrings is an xcode command line tool for generating a Localizable.strings file from
     all NSLocalizedString calls in your app.
     https://developer.apple.com/library/mac/documentation/Darwin/Reference/ManPages/man1/genstrings.1.html
     http://blog.spritebandits.com/2012/01/25/ios-iphone-app-localization-genstrings-tips/
    */
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];

    NSString *oneMillion = [numberFormatter stringFromNumber:@(1000000)];
    self.localizationLabel.text = [NSString stringWithFormat:NSLocalizedString(@"NUMBER: %@", nil), oneMillion];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showPeoplePicker:(id)sender
{
    ABPeoplePickerNavigationController *picker =
    [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    // Only want to allow the user to select address entries
    picker.displayedProperties = @[[NSNumber numberWithInt:kABPersonAddressProperty]];

    [self presentViewController:picker animated:YES completion:nil];
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    // return YES shows contact details view with list of contact properties
    return YES;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier
{
    if (property == kABPersonAddressProperty) {
        NSString *address = [self getAddress:person atIdentifier:identifier];
        self.selectedAddressLabel.text = address;

        // TODO: Store address information in CoreData once implemented
        [_userDefaults setObject:address forKey:USER_DEFAULTS_STORED_ADDRESS];

        [peoplePicker dismissViewControllerAnimated:YES completion:nil];
        return NO;
    }

    return YES;
}

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
}

- (NSString *) getAddress: (ABRecordRef) person
          atIdentifier: (ABMultiValueIdentifier) identifier
{
    ABMultiValueRef addresses = ABRecordCopyValue(person, kABPersonAddressProperty);
    NSArray *addressesArray = (__bridge_transfer NSArray *) ABMultiValueCopyArrayOfAllValues(addresses);
    const NSUInteger addressIndex = ABMultiValueGetIndexForIdentifier(addresses, identifier);
    NSDictionary *addressDict = [addressesArray objectAtIndex:addressIndex];
    NSString *street = [addressDict objectForKey:(NSString *) kABPersonAddressStreetKey];
    NSString *city = [addressDict objectForKey:(NSString *) kABPersonAddressCityKey];
    NSString *state = [addressDict objectForKey:(NSString *) kABPersonAddressStateKey];
    NSString *zip = [addressDict objectForKey:(NSString *) kABPersonAddressZIPKey];
    NSString *country = [addressDict objectForKey:(NSString *) kABPersonAddressCountryKey];
    NSString *address = [NSString stringWithFormat:@"%@, %@, %@, %@ %@", street, city, state, zip, country];
    CFRelease(addresses);
    return address;
}

@end
