//
//  PollingLocationWrapper.m
//  VotingInformationProject
//
//  Created by Bennet Huber on 3/17/14.
//

#import "PollingLocationWrapper.h"
#import "PollingLocationCell.h"
#import "EarlyVoteSite.h"
#import "DropoffLocation.h"
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
        NSString *locationName = self.location.address.locationName;
        if (!locationName) {
            locationName = self.location.name;
        }
        tableCell.name.text = locationName;
        if ([self.location isMemberOfClass:[EarlyVoteSite class]]) {
            tableCell.image.image = [UIImage imageNamed:@"Polling_earlyvoting"];
        } else if ([self.location isMemberOfClass:[DropoffLocation class]]) {
            tableCell.image.image = [UIImage imageNamed:@"Polling_dropoff"];
        } else {
            tableCell.image.image = [UIImage imageNamed:@"Polling_location"];
        }
        // Grey out image if no lat/lon on table cell init (not geocoded yet!)
        if ([self.location.address.latitude doubleValue] < VA_MIN_LAT ||
            [self.location.address.longitude doubleValue] < VA_MIN_LON) {
            self.tableCell.image.alpha = 0.5f;
        }
        [self _updateDistance];
        [self updateTableCellAccessibility];
    }
}

- (void)updateTableCellAccessibility
{
    // set accessibility of tableCell
    self.tableCell.isAccessibilityElement = YES;
    NSString *accessibilityLabel = [self.location isMemberOfClass:[EarlyVoteSite class]] ?
    NSLocalizedString(@"Early Vote Site", @"Polling Location Cell Accessibility Label - Early Vote Site") :
    NSLocalizedString(@"Polling Site", @"Polling Location Cell Accessibility Label - Polling Site");
    self.tableCell.accessibilityLabel = accessibilityLabel;
    
    NSString *accessibilityValue = [NSString stringWithFormat:@"%@. %@. %@",
                                    self.name, self.address, self.tableCell.distance.text];
    self.tableCell.accessibilityValue = accessibilityValue;
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
    // staticlaly define things once to save expense on creating them
    // http://nshipster.com/nsformatter/
    static dispatch_once_t onceToken;
    static NSNumberFormatter *_numberFormatter = nil;
    static NSString *_unknown = nil;
    static NSString *_suffix = nil;
    dispatch_once(&onceToken, ^{
        _numberFormatter = [[NSNumberFormatter alloc] init];
        [_numberFormatter setLocale:[NSLocale currentLocale]];
        [_numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [_numberFormatter setMaximumFractionDigits:1];

        _unknown = NSLocalizedString(@"-- mi", @"Indicate distance is unknown # of miles");
        _suffix = NSLocalizedString(@"mi", @"Abbreviation for miles");
    });

    if ((a.latitude == NullCoordinate.latitude && a.longitude == NullCoordinate.longitude) ||
        (b.latitude == NullCoordinate.latitude && b.longitude == NullCoordinate.longitude)) {
        return _unknown;
    }

    CLLocation *x = [[CLLocation alloc] initWithLatitude:a.latitude longitude:a.longitude];
    CLLocation *y = [[CLLocation alloc] initWithLatitude:b.latitude longitude:b.longitude];

    // TODO: flexible unit conversion?
    // CLLocationDistance distanceInMeters = fabs([x distanceFromLocation:y]);
    // meters * (100 cm / meter) * (1 inch / 2.54 cm) * (1 ft / 12 inch) * (1 mile / 5280')
    // 100 / 2.54 / 12 / 5280 = 0.00062137119224
    CLLocationDistance distance = fabs([x distanceFromLocation:y]) * 0.00062137119224;

    NSString *distString = [_numberFormatter stringFromNumber:[NSNumber numberWithDouble:distance]];
    return [distString stringByAppendingString:_suffix];
}

- (void)_updateDistance
{
    if (self.tableCell && self.tableCell.owner == self) {
        _distance = [PollingLocationWrapper getDistanceStringFromA:self.mapOrigin
                                                               toB:self.mapPosition];
        self.tableCell.distance.text = _distance;
        [self updateTableCellAccessibility];
    }
}

@end
