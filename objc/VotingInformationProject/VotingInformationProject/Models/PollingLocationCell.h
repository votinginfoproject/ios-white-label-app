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

/** Bogus map coordinate to denote unset values */
extern const CLLocationCoordinate2D NullCoordinate;

@property (strong, nonatomic) PollingLocation *location;
@property (weak, nonatomic) GMSMarker *marker;

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *type;       // TODO: display early voting type in UI?
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *distance;
@property (weak, nonatomic) IBOutlet UIImageView *image;

@property CLLocationCoordinate2D mapOrigin;
@property CLLocationCoordinate2D mapPosition;


/** Handler for when the row is selected.  Gets passed self as its parameter.
 */
@property (strong, nonatomic) void (^onRowSelected)(PollingLocationCell*);

/** Handler for when the row is selected.  Gets passed self as its parameter.
 */
@property (strong, nonatomic) void (^onGeocodeComplete)(PollingLocationCell*);

/** Resets properties of self so it can be reused as a new table cell
 */
- (void) reset;

/** Main function for setting properties on this object
 *
 * @param location: Location object we're displaying
 * @param position: Coordinates of location object
 * @param origin: Coordinates of user address, used to calculate distance
 */
- (void)updateLocation:(PollingLocation *)location withMapOrigin:(CLLocationCoordinate2D)mapOrigin;

// TODO: move to utilities class?
/** Gets distance between two points as a pretty string
 */
+ (NSString*)getDistanceStringFromA:(CLLocationCoordinate2D)a toB:(CLLocationCoordinate2D)b;

@end
