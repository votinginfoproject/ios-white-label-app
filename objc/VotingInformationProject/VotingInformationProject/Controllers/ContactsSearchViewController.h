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

@interface ContactsSearchViewController : VIPViewController

@property (weak, nonatomic) id<ContactsSearchViewControllerDelegate>delegate;

@property (strong, nonatomic) UserElection *currentElection;

@end
