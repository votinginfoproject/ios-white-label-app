//
//  PollingLocationCell.h
//  VotingInformationProject
//
//  Created by Bennet Huber on 3/10/14.
//

#import <UIKit/UIKit.h>
#import "GoogleMaps/GoogleMaps.h"

@class PollingLocationWrapper;

@interface PollingLocationCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *type;       // TODO: display early voting type in UI?
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *distance;
@property (weak, nonatomic) IBOutlet UIImageView *image;

/** Reference to the PollingLocationWrapper currently pointing at this cell.
 *  We need this because the UITableViewController secretly reuses these objects
 *  in the background, so PollingLocationWrapper.tableCell may point to a cell
 *  that is in fact being used by another PollingLocationWrapper instance.
 *  This property allows PollingLocationWrapper to ensure it should be updating
 *  properties on this object.
 */
@property (weak, nonatomic) PollingLocationWrapper *owner;

/** Handler for when the row is selected.  Gets passed self as its parameter.
 */
@property (strong, nonatomic) void (^onRowSelected)(PollingLocationCell*);

@end
