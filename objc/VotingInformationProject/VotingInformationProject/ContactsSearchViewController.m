//
//  ContactsSearchViewController.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 1/22/14.
//  Copyright (c) 2014 Bennet Huber. All rights reserved.
//

#import "ContactsSearchViewController.h"

@interface ContactsSearchViewController ()

@property (weak, nonatomic) IBOutlet UISearchBar *addressSearchBar;
@property (weak, nonatomic) IBOutlet UIButton *showPeoplePicker;
@property (weak, nonatomic) IBOutlet UILabel *selectedAddressLabel;

@end

@implementation ContactsSearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    // Load contacts from Address Book on view load
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) saveAddress: (ABRecordRef) person {
    NSString* address = nil;
    ABMultiValueRef addresses = ABRecordCopyValue(person,
                                                     kABPersonAddressProperty);
    if (ABMultiValueGetCount(addresses) > 0) {
        address = (__bridge_transfer NSString*)
        ABMultiValueCopyValueAtIndex(addresses, 0);
    } else {
        address = @"[None]";
    }
    self.selectedAddressLabel.text = address;
    CFRelease(addresses);
}


- (IBAction)showPeoplePicker:(id)sender {
    ABPeoplePickerNavigationController *picker =
    [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;

    [self presentModalViewController:picker animated:YES];
}

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker {
    [self dismissModalViewControllerAnimated:YES];
}


- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person {

    [self saveAddress:person];
    [self dismissModalViewControllerAnimated:YES];
    return NO;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier
{
    return NO;
}

@end
