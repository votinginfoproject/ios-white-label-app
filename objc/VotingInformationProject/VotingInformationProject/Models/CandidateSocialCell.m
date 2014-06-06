//
//  CandidateSocialCell.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/18/14.
//

#import "CandidateSocialCell.h"

@implementation CandidateSocialCell

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
}

- (void)configure:(SocialChannel *)socialChannel
{
    NSString *title = [NSString stringWithFormat:
                       NSLocalizedString(@"View on %@", @"View on {social media type, i.e. Facebook/Twitter}"),
                       socialChannel.type];
    self.socialLabel.text = title;
    self.url = [socialChannel url];
    self.imageView.image = [socialChannel logo];
}

@end
