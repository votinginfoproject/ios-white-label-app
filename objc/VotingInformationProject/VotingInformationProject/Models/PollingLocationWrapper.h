//
//  PollingLocationWrapper.h
//  VotingInformationProject
//
//  Created by Bennet Huber on 3/17/14.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PollingLocation.h"
#import "PollingLocationCell.h"
#import "GoogleMaps/GoogleMaps.h"

/** A sort of view controller class for PollingLocationCell and related data
 *
 * This isn't actually a view controller, although maybe it should be refactored into one (?)
 * It is responsible for several things:
 *      - Asynchronous geocoding of location.address and updating the tableCell view accordingly
 *      - Tying changes to it's properties to changes in the tableCell view
 *      - Calculating distance between mapOrigin and mapPosition
 */
@interface PollingLocationWrapper : NSObject

/** Bogus map coordinate to denote unset values */
extern const CLLocationCoordinate2D NullCoordinate;

/** UITableViewCell corresponding to this object.
 *  As a side effect it updates all the display properties of the UITableViewCell to match
 *  the pertinent properties of self.
 *  Note: This MUST be reset every time
 *  UITableViewController (UITableViewCell*)tableView:(UITableView *) cellForRowAtIndexPath:(NSIndexPath *)
 *  is called, as the object may be stale by then.
 */
@property (weak, nonatomic) PollingLocationCell *tableCell;

/** Location containing the data we're displaying.
 *
 * Setting this property will trigger a geocode provided it's not nil and different from the current
 * value.  Setting self.onGeocodeComplete first is a good idea to avoid race conditions.
 */
@property (strong, nonatomic) PollingLocation *location;

/** Map marker for this location (may be nil)
 *
 * Setting this to nil will automatically set self.marker.map = nil as well.
 */
@property (strong, nonatomic) GMSMarker *marker;

/** tableCell.name.text, derived from self.location */
@property (strong, nonatomic, readonly) NSString *name;

/** tableCell.address.text, derived from self.location */
@property (strong, nonatomic, readonly) NSString *address;

/** tableCell.distance.text, derived from self.mapOrigin and self.mapPostion.
 *
 * If either self.mapOrigin or self.mapPosition is NullCoordinate, this will be "...".
 */
@property (strong, nonatomic, readonly) NSString *distance;

/** If NO, geocode didn't succeed, otherwise either it did or it hasn't completed yet
 */
@property BOOL geocodeSucceeded;

/** Location of the "center" of the map that we measure distances from (usually user address) */
@property CLLocationCoordinate2D mapOrigin;

/** lat-long of location.  Set to NullCoordinate until geocoding completes, implicitly set by location */
@property CLLocationCoordinate2D mapPosition;

/** Handler for when the row is selected.
 *
 * Gets passed self as its parameter first parameter and any errors encountered while geocoding as
 * the second.  Called regardless of geocode success.
 */
@property (strong, nonatomic) void (^onGeocodeComplete)(PollingLocationWrapper*, NSError*);

/** Initializer that takes location and onGeocodeComplete. */
- (PollingLocationWrapper*) initWithLocation:(PollingLocation*)location andGeocodeHandler:(void(^)(PollingLocationWrapper*, NSError*))onGeocodeComplete;

/** Clears properties of self so it can be reused as a new table cell
 */
- (void) reset;

// TODO: move to utilities class?
/** Gets distance between two points as a pretty string
 */
+ (NSString*)getDistanceStringFromA:(CLLocationCoordinate2D)a toB:(CLLocationCoordinate2D)b;


@end
