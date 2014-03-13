//
//  BallotDetailsViewController.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 3/13/14.
//

#import <UIKit/UIKit.h>
#import "Election+API.h"

@interface BallotDetailsViewController : UITableViewController

@property (strong, nonatomic) Election *election;

@end
