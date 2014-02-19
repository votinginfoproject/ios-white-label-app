//
//  CandidateLinkCell.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/18/14.
//

#import <UIKit/UIKit.h>

#import "Candidate+API.h"

@interface CandidateLinkCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, weak) IBOutlet UIButton *linkButton;
@property (nonatomic) CandidateLinkTypes linkType;

/**
 *  Set all properties of the CandidateLinkCell
 *
 *  @param link An NSDictionary with the keys:
 *                  @"description"
 *                  @"buttonTitle"
 *                  @"url"
 *                  @"urlScheme"
 *
 *  @see Candidate+API.h getLinksDataArray
 */
- (void) configure:(NSDictionary*)link;

@end
