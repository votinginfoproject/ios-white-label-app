//
//  VIPTabBarController.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/7/14.
//  
//

#import <UIKit/UIKit.h>

#import "BallotViewController.h"
#import "Election+API.h"

@interface VIPTabBarController : UITabBarController

@property (strong, nonatomic) NSArray *elections;
@property (strong, nonatomic) Election *currentElection;
@property (strong, nonatomic) NSString *currentParty;

@end
