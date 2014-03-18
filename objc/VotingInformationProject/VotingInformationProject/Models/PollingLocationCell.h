//
//  PollingLocationCell.h
//  VotingInformationProject
//
//  Created by Bennet Huber on 3/10/14.
//

#import <UIKit/UIKit.h>
#import "PollingLocation.h"
#import "GoogleMaps/GoogleMaps.h"

@interface PollingLocationCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *type;       // TODO: display early voting type in UI?
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *distance;
@property (weak, nonatomic) IBOutlet UIImageView *image;

/** Handler for when the row is selected.  Gets passed self as its parameter.
 */
@property (strong, nonatomic) void (^onRowSelected)(PollingLocationCell*);

@end
