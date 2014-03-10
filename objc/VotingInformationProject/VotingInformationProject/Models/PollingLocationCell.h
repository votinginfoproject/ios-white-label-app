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

@property (strong, nonatomic) PollingLocation *location;

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *type;       // TODO: display early voting type in UI?
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *distance;
@property (weak, nonatomic) IBOutlet UIImageView *image;

@property CLLocationCoordinate2D origin;
@property CLLocationCoordinate2D position;

/** Main function for setting properties on this object
 *
 * @param location: Location object we're displaying
 * @param position: Coordinates of location object
 * @param origin: Coordinates of user address, used to calculate distance
 */
- (void)updateLocation:(PollingLocation *)location withPosition:(CLLocationCoordinate2D)position andWithOrigin:(CLLocationCoordinate2D)origin;

// TODO: move somewhere else, PollingLocation+API maybe?
/** Parses a location object into an address string
 *
 * @param location: Location to get address from
 * @result Pretty address string
 */
+ (NSString*)getAddressText:(PollingLocation* )location;

// TODO: move to utilities class?
/** Gets distance between two points as a pretty string
 */
+ (NSString*)getDistanceStringFromA:(CLLocationCoordinate2D)a toB:(CLLocationCoordinate2D)b;

@end
