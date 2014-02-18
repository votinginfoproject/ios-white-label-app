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
    self.url = [socialChannel uniqueUrl];
    self.imageView.image = [self imageForType:socialChannel.type];
}

/**
 Get the proper social media logo as UIImage based on type
 *
 * @param type One of the string social media types returned by the votinginfoquery channels API
 *
 * @return UIImage* The image, or nil if no type matches
 */
- (UIImage*)imageForType:(NSString*)type
{
    UIImage *image = nil;
    NSString *lowerCaseType = [type lowercaseString];
    if ([lowerCaseType isEqualToString:@"facebook"]) {
        image = [UIImage imageNamed:@"facebook-logo-blue"];
    } else if ([lowerCaseType isEqualToString:@"twitter"]) {
        image = [UIImage imageNamed:@"twitter-logo-blue"];
    } else if ([lowerCaseType isEqualToString:@"googleplus"]) {
        image = [UIImage imageNamed:@"googleplus-logo-red"];
    } else if ([lowerCaseType isEqualToString:@"youtube"]) {
        image = [UIImage imageNamed:@"youtube-logo-red"];
    }
    return image;
}

@end
