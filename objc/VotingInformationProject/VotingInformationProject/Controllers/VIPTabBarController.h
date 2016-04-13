//
//  VIPTabBarController.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/7/14.
//  
//

#import <UIKit/UIKit.h>

#import "BallotViewController.h"
#import "UserElection+API.h"

@interface VIPTabBarController : UITabBarController

@property (strong, nonatomic) NSArray *elections;
@property (strong, nonatomic) UserElection *currentElection;
@property (strong, nonatomic) NSString *currentParty;
@property (nonatomic) int defaultIndex;

/**
 *  Return YES if all data necessary to restore the app from a saved state
 *  is available in the UserDefaults/CoreData caches
 *
 *  Currently "all data" refers to an elections array, a current election,
 *  and a selected political party.
 *
 *  @return YES if all data available, NO otherwise
 */
- (BOOL)isVIPDataAvailable;

@end
