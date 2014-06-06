//
//  ContestUrlCell.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/19/14.
//

#import "ContestUrlCell.h"

@implementation ContestUrlCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configure:(NSString *)title withUrl:(NSString *)stringUrl
{
    self.textLabel.text = title;
    self.url = [NSURL URLWithString:stringUrl];
}

@end
