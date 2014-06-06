//
//  BallotDetailsViewController.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 3/13/14.
//

#import <UIKit/UIKit.h>
#import "VIPTableViewController.h"
#import "ContactsSearchViewControllerDelegate.h"
#import "Election+API.h"

@interface BallotDetailsViewController : VIPTableViewController <ContactsSearchViewControllerDelegate>

@property (strong, nonatomic) Election *election;

@end
