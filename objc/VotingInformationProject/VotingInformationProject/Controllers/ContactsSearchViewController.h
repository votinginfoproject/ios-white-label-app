//
//  ContactsSearchViewController.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 1/22/14.
//  Copyright (c) 2014 Bennet Huber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBookUI/AddressBookUI.h>

#import "VIPUserDefaultsKeys.h"
#import "UserAddress+API.h"

@interface ContactsSearchViewController : UIViewController <ABPeoplePickerNavigationControllerDelegate>

- (IBAction) showPeoplePicker:(id)sender;

- (NSString *) getAddress: (ABRecordRef) person atIdentifier:(ABMultiValueIdentifier) identifier;

@end
