//
//  ContactsSearchViewController.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 1/22/14.
//  
//

#import <UIKit/UIKit.h>
#import <AddressBookUI/AddressBookUI.h>

#import "VIPViewController.h"
#import "UIWebViewController.h"
#import "VIPTabBarController.h"

#import "VIPUserDefaultsKeys.h"
#import "UserAddress+API.h"
#import "Election+API.h"

@interface ContactsSearchViewController : VIPViewController <ABPeoplePickerNavigationControllerDelegate>

- (IBAction) showPeoplePicker:(id)sender;

- (NSString *) getAddress: (ABRecordRef) person atIdentifier:(ABMultiValueIdentifier) identifier;

@end
