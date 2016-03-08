//
//  CandidateLinkCell.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/18/14.
//

#import "CandidateLinkCell.h"
#import "VIPColor.h"

@interface CandidateLinkCell()

@end

@implementation CandidateLinkCell

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

- (void)configure:(NSDictionary *)link
{
    self.descriptionLabel.text = link[@"description"];
    self.descriptionLabel.textColor = [VIPColor primaryTextColor];
    self.linkLabel.text = link[@"buttonTitle"];
    self.linkLabel.textColor = [VIPColor linkColor];
    self.linkType = (CandidateLinkTypes)[link[@"urlScheme"] integerValue];
    self.url = link[@"url"];
}

@end
