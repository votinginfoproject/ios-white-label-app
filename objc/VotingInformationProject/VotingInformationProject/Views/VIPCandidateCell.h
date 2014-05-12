//
//  VIPCandidateCell.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 5/12/14.
//

#import <UIKit/UIKit.h>

@interface VIPCandidateCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *partyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@end
