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
#import "ContactsSearchViewControllerDelegate.h"


@class ContactsSearchViewController;

@interface ContactsSearchViewController : VIPViewController <ABPeoplePickerNavigationControllerDelegate>

@property (weak, nonatomic) id<ContactsSearchViewControllerDelegate>delegate;

- (IBAction) showPeoplePicker:(id)sender;

- (NSString *) getAddress: (ABRecordRef) person atIdentifier:(ABMultiValueIdentifier) identifier;

@property (strong, nonatomic) UserElection *currentElection;

@end
