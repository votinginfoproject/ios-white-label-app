//
//  ContestUrlCell.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/19/14.
//

#import <UIKit/UIKit.h>

#define CONTEST_URL_CELLID @"ContestUrlPropertiesCell"

@interface ContestUrlCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, weak) IBOutlet UILabel *urlLabel;

@property (strong, nonatomic) NSURL *url;

@end
