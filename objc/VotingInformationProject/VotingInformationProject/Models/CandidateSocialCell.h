//
//  CandidateSocialCell.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/18/14.
//  Copyright (c) 2014 Bennet Huber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocialChannel+API.h"

@interface CandidateSocialCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *socialLabel;
@property (nonatomic, weak) IBOutlet UIImageView *socialLogo;
@property (strong, nonatomic) NSURL *url;

/**
 *  Configure the properties of a CandidateSocialCell from a SocialChannel instance
 *
 *  @param socialChannel The SocialChannel instance to configure with
 */
- (void)configure:(SocialChannel*)socialChannel;

@end
