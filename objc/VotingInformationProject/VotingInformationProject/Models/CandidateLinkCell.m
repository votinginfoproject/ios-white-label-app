//
//  CandidateLinkCell.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/18/14.
//

#import "CandidateLinkCell.h"
#import "VIPColor.h"

@interface CandidateLinkCell()

@property (strong, nonatomic) NSString* url;

- (IBAction)linkPressed:(id)sender;

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
    [self.linkButton setTitleColor:[VIPColor linkColor] forState:UIControlStateNormal];
    [self.linkButton setTitle:link[@"buttonTitle"] forState:UIControlStateNormal];
    self.linkType = [link[@"urlScheme"] integerValue];
    self.url = link[@"url"];
}

/**
 *  Set url property from a string, detecting the url scheme from the linkType property
 *
 *  @param url Url to set, without a scheme
 */
- (void)setUrl:(NSString *)url
{
    if (self.linkType == kCandidateLinkTypeWebsite) {
        _url = url;
    } else if (self.linkType == kCandidateLinkTypePhone) {
        _url = [NSString stringWithFormat:@"telprompt:%@", url];
    } else if (self.linkType == kCandidateLinkTypeEmail) {
        _url = [NSString stringWithFormat:@"mailto:%@", url];
    } else {
        _url = nil;
    }
    // Disable link button if we can't open the newly created url
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:_url ]]) {
        self.linkButton.enabled = NO;
    }
}

/**
 *  Open the url with appropriate scheme when linkButton is tapped
 *
 *  @param sender UIButton that sent this message
 */
- (IBAction)linkPressed:(id)sender
{
    // TODO: Open links in specific apps!

    NSURL *url = [NSURL URLWithString:self.url];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    } else {
        NSLog(@"Unable to open URL: %@", url);
    }
}

@end
