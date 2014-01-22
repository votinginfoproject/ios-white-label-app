//
//  ContactsSearchViewController.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 1/22/14.
//  Copyright (c) 2014 Bennet Huber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBookUI/AddressBookUI.h>

@interface ContactsSearchViewController : UIViewController <ABPeoplePickerNavigationControllerDelegate>

@property (strong, nonatomic) NSMutableArray *contactsList;

@end
