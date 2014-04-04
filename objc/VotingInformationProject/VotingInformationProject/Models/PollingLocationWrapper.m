//
//  PollingLocationWrapper.m
//  VotingInformationProject
//
//  Created by Bennet Huber on 3/17/14.
//

#import "PollingLocationWrapper.h"
#import "PollingLocationCell.h"
#import "VIPAddress.h"
#import "VIPAddress+API.h"

@implementation PollingLocationWrapper {
    NSString *_distance;
    CLLocationCoordinate2D _mapOrigin;
    PollingLocationCell *_tableCell;
    PollingLocation* _location;
    GMSMarker *_marker;
}

const CLLocationCoordinate2D NullCoordinate = {-999, -999};

#pragma mark - Setup/Teardown

- (PollingLocationWrapper*) init
{
    self = [super init];
    if (self != nil) {
        [self reset];
        self.geocodeSucceeded = YES;
    }
    return self;
}

- (PollingLocationWrapper*) initWithLocation:(PollingLocation*)location andGeocodeHandler:(void(^)(PollingLocationWrapper*, NSError*))onGeocodeComplete
{
    self = [self init];
    if (self != nil) {
        self.onGeocodeComplete = onGeocodeComplete;
        self.location = location;
    }
    return self;
}

- (void) reset
{
    self.location = nil;
    self.mapPosition = NullCoordinate;
    self.mapOrigin = NullCoordinate;
    _distance = @"...";
    if (_tableCell.owner == self) {
        _tableCell.owner = nil;
    }
    _tableCell = nil;
    self.marker = nil;
    self.geocodeSucceeded = YES;
}

#pragma mark - Properties

- (NSString*) address
{
    return self.location && self.location.address ? [self.location.address toABAddressString:NO] : @"";
}

- (NSString*) name
{
    if (self.location) {
        if (self.location.name.length > 0) {
            return self.location.name;
        } else {
            NSString *result = self.location.address.locationName;
            return result.length > 0 ? result : @"";
        }
    } else {
        return @"";
    }
}

- (CLLocationCoordinate2D)mapOrigin
{
    return _mapOrigin;
}

- (void)setMapOrigin:(CLLocationCoordinate2D)mapOrigin
{
    _mapOrigin = mapOrigin;
    [self _updateDistance];
}

- (PollingLocation*)location
{
    return _location;
}

- (void)setLocation:(PollingLocation *)location
{
    if (!location) {
        _location = location;
    } else if (location != _location) {
        _location = location;
        [self.location.address geocode:^(CLLocationCoordinate2D position, NSError *error) {
            float alpha = 1;
            if (error) {
                self.geocodeSucceeded = NO;
                alpha = 0.5;
            } else {
                self.mapPosition = position;
                [self _updateDistance];
            }
            if (self.tableCell && self.tableCell.owner == self) {
                self.tableCell.image.alpha = alpha;
            }
            if (self.onGeocodeComplete) {
                self.onGeocodeComplete(self, error);
            }
        }];
    }
}

- (PollingLocationCell*)tableCell
{
    return _tableCell;
}

- (void)setTableCell:(PollingLocationCell *)tableCell
{
    _tableCell = tableCell;
    if (self.tableCell && self.location) {
        tableCell.owner = self;
        tableCell.address.text = self.address;
        tableCell.name.text = self.name;
        tableCell.image.image = [self.location.isEarlyVoteSite boolValue]
                                 ? [UIImage imageNamed:@"Polling_earlyvoting"]
                                 : [UIImage imageNamed:@"Polling_location"];
        // Grey out image if no lat/lon on table cell init (not geocoded yet!)
        if ([self.location.address.latitude doubleValue] < VA_MIN_LAT ||
            [self.location.address.longitude doubleValue] < VA_MIN_LON) {
            self.tableCell.image.alpha = 0.5f;
        }
        [self _updateDistance];
    }
}

 - (GMSMarker*)marker
{
    return _marker;
}

- (void)setMarker:(GMSMarker *)marker
{
    if (_marker) {
        _marker.map = nil;
    }
    _marker = marker;
}



+ (NSString*)getDistanceStringFromA:(CLLocationCoordinate2D)a toB:(CLLocationCoordinate2D)b
{
    if ((a.latitude == NullCoordinate.latitude && a.longitude == NullCoordinate.longitude) ||
        (b.latitude == NullCoordinate.latitude && b.longitude == NullCoordinate.longitude)) {
        return NSLocalizedString(@"-- mi", @"Indicate distance is unknown # of miles");
    }
    CLLocation *x = [[CLLocation alloc] initWithLatitude:a.latitude longitude:a.longitude];
    CLLocation *y = [[CLLocation alloc] initWithLatitude:b.latitude longitude:b.longitude];
    CLLocationDistance distanceInMeters = fabs([x distanceFromLocation:y]);
    // TODO: flexible unit conversion?
    // meters * (100 cm / meter) * (1 inch / 2.54 cm) * (1 ft / 12 inch) * (1 mile / 5280')
    CLLocationDistance distance = distanceInMeters * 100 / 2.54 / 12 / 5280;
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setLocale:[NSLocale currentLocale]];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setMaximumFractionDigits:1];
    NSString *distString = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:distance]];
    NSString *suffix = NSLocalizedString(@"mi", @"Abbreviation for miles");
    return [distString stringByAppendingString:suffix];
}

- (void)_updateDistance
{
    if (self.tableCell && self.tableCell.owner == self) {
        _distance = [PollingLocationWrapper getDistanceStringFromA:self.mapOrigin
                                                               toB:self.mapPosition];
        self.tableCell.distance.text = _distance;
    }
}

@end
