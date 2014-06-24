//
//  BallotViewController.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/7/14.
//

#import <UIKit/UIKit.h>

#import "VIPTableViewController.h"
#import "VIPTabBarController.h"
#import "UserElection+API.h"
#import "ContactsSearchViewControllerDelegate.h"

@interface BallotViewController : VIPTableViewController <ContactsSearchViewControllerDelegate>

@property (strong, nonatomic) UserElection *election;

@end
