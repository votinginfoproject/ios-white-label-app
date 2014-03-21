//
//  CandidateDetailsViewController.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/17/14.
//

#import <UIKit/UIKit.h>

#import "VIPViewController.h"
#import "Candidate+API.h"
#import "CandidateLinkCell.h"
#import "CandidateSocialCell.h"
#import "SocialChannel.h"

@interface CandidateDetailsViewController : VIPViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) Candidate* candidate;

@end
