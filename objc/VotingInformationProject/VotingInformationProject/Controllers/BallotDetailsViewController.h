//
//  BallotDetailsViewController.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 3/13/14.
//

#import <UIKit/UIKit.h>
#import "VIPTableViewController.h"
#import "Election+API.h"

@interface BallotDetailsViewController : VIPTableViewController

@property (strong, nonatomic) Election *election;

@end
