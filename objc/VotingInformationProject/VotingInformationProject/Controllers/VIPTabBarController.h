//
//  VIPTabBarController.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/7/14.
//  Copyright (c) 2014 Bennet Huber. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BallotViewController.h"
#import "Election+API.h"

@interface VIPTabBarController : UITabBarController

@property (strong, nonatomic) Election *election;

@end
