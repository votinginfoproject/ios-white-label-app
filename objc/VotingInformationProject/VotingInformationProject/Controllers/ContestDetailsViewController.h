//
//  ContestDetailsViewController.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/13/14.
//

#import <UIKit/UIKit.h>

#import "VIPViewController.h"
#import "Contest+API.h"

@class ContestDetailsViewController;

@protocol ContestDetailsViewControllerDelegate <NSObject>

- (void)contestDetailsViewControllerDidClose:(ContestDetailsViewController*)controller;

@end

/**
 A Table View controller for displaying details about a Contest*
 Has two sections, first is key/value properties of the contest,
 second is a list of candidates for the contest
 */
@interface ContestDetailsViewController : VIPViewController <UITableViewDataSource, UITableViewDelegate>

extern NSString * const REFERENDUM_API_ID;

/**
 The Contest* displayed by this view
 */
@property (strong, nonatomic) Contest* contest;
/**
 The election name associated with this contest
 */
@property (strong, nonatomic) NSString* electionName;
@property (weak, nonatomic) id<ContestDetailsViewControllerDelegate>delegate;

@end

