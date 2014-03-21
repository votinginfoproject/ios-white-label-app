//
//  BallotViewController.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/7/14.
//

#import <UIKit/UIKit.h>

#import "VIPTableViewController.h"
#import "VIPTabBarController.h"
#import "Election+API.h"

@interface BallotViewController : VIPTableViewController

@property (strong, nonatomic) Election *election;

@end
