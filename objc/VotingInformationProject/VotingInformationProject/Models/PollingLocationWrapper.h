//
//  PollingLocationWrapper.h
//  VotingInformationProject
//
//  Created by Bennet Huber on 3/17/14.
//  Copyright (c) 2014 Bennet Huber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PollingLocation.h"
#import "PollingLocationCell.h"
#import "GoogleMaps/GoogleMaps.h"

@interface PollingLocationWrapper : NSObject

/** Bogus map coordinate to denote unset values */
extern const CLLocationCoordinate2D NullCoordinate;

@property (strong, nonatomic) PollingLocationCell *tableCell;

@property (strong, nonatomic) PollingLocation *location;
@property (weak, nonatomic) GMSMarker *marker;
@property (strong, nonatomic, readonly) NSString *name;
@property (strong, nonatomic, readonly) NSString *address;
@property (strong, nonatomic, readonly) NSString *distance;

@property CLLocationCoordinate2D mapOrigin;
@property CLLocationCoordinate2D mapPosition;

/** Handler for when the row is selected.  Gets passed self as its parameter.
 */
@property (strong, nonatomic) void (^onGeocodeComplete)(PollingLocationWrapper*, NSError*);

- (PollingLocationWrapper*) initWithLocation:(PollingLocation*)location andGeocodeHandler:(void(^)(PollingLocationWrapper*, NSError*))onGeocodeComplete;

/** Resets properties of self so it can be reused as a new table cell
 */
- (void) reset;

// TODO: move to utilities class?
/** Gets distance between two points as a pretty string
 */
+ (NSString*)getDistanceStringFromA:(CLLocationCoordinate2D)a toB:(CLLocationCoordinate2D)b;


@end
