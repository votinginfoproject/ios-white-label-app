//
//  VIPContestPropertiesCell.m
//  VotingInformationProject
//
//  Created by Chris Anderson on 8/29/15.
//  Copyright © 2015 The Pew Charitable Trusts. All rights reserved.
//

#import "VIPContestPropertiesCell.h"

@implementation VIPContestPropertiesCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
      if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
        self.subtitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.subtitleLabel.numberOfLines = 0;
        self.subtitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.subtitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
          
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.subtitleLabel];
          
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[bodyLabel]-10-|" options:0 metrics:nil views:@{ @"bodyLabel": self.titleLabel, @"subtitleLabel" : self.subtitleLabel }]];
      
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[subtitleLabel]-10-|" options:0 metrics:nil views:@{ @"bodyLabel": self.titleLabel, @"subtitleLabel" : self.subtitleLabel }]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[bodyLabel(20)][subtitleLabel]|" options:0 metrics:nil views:@{ @"bodyLabel": self.titleLabel, @"subtitleLabel" : self.subtitleLabel }]];
    }
    return self;
}

- (void)awakeFromNib {
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[bodyLabel]-10-|" options:0 metrics:nil views:@{ @"bodyLabel": self.titleLabel, @"subtitleLabel" : self.subtitleLabel }]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[subtitleLabel]-10-|" options:0 metrics:nil views:@{ @"bodyLabel": self.titleLabel, @"subtitleLabel" : self.subtitleLabel }]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[bodyLabel][subtitleLabel]|" options:0 metrics:nil views:@{ @"bodyLabel": self.titleLabel, @"subtitleLabel" : self.subtitleLabel }]];
}

@end
