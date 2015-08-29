//
//  VIPContestCell.m
//  VotingInformationProject
//
//  Created by Chris Anderson on 8/21/15.
//  Copyright © 2015 The Pew Charitable Trusts. All rights reserved.
//

#import "VIPContestCell.h"

@implementation VIPContestCell

- (void)awakeFromNib {
    self.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.textLabel.numberOfLines = 0;
    self.textLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.detailTextLabel.numberOfLines = 0;
    self.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.detailTextLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-14-[bodyLabel]-10-|" options:0 metrics:nil views:@{ @"bodyLabel": self.textLabel, @"subtitleLabel" : self.detailTextLabel }]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-14-[subtitleLabel]-10-|" options:0 metrics:nil views:@{ @"bodyLabel": self.textLabel, @"subtitleLabel" : self.detailTextLabel }]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[bodyLabel][subtitleLabel]-6-|" options:0 metrics:nil views:@{ @"bodyLabel": self.textLabel, @"subtitleLabel" : self.detailTextLabel }]];
    }
    

@end
