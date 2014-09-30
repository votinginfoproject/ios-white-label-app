//
//  AboutViewController.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/19/14.
//

#import <UIKit/UIKit.h>
#import "VIPTableViewController.h"
#import "ContactsSearchViewControllerDelegate.h"

@class AboutViewController;

@protocol AboutViewControllerDelegate <NSObject>

- (void)aboutViewControllerDidClose:(AboutViewController *)controller;

@end

@interface AboutViewController : VIPTableViewController

@property (nonatomic, weak) id <AboutViewControllerDelegate> delegate;

@end
