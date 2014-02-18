//
//  CandidateDetailsViewController.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/17/14.
//

#import <UIKit/UIKit.h>

#import "Candidate+API.h"
#import "CandidateLinkCell.h"
#import "CandidateSocialCell.h"
#import "SocialChannel.h"

@interface CandidateDetailsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) Candidate* candidate;

@end
