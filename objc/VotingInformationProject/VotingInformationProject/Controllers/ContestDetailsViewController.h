//
//  ContestDetailsViewController.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/13/14.
//

#import <UIKit/UIKit.h>

#import "Contest+API.h"

@interface ContestDetailsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) Contest* contest;
@property (strong, nonatomic) NSString* electionName;

@end
