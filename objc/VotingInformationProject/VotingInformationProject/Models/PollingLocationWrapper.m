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
    }
    return self;
}

- (PollingLocationWrapper*) initWithLocation:(PollingLocation*)location andGeocodeHandler:(void(^)(PollingLocationWrapper*, NSError*))onGeocodeComplete
{
    self = [self init];
    if (self != nil) {
        self.location = location;
        self.onGeocodeComplete = onGeocodeComplete;
    }
    return self;
}

- (void) reset
{
    self.location = nil;
    self.mapPosition = NullCoordinate;
    self.mapOrigin = NullCoordinate;
    _distance = @"...";
    _tableCell = nil;
    self.marker = nil;
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
            if (!error) {
                self.mapPosition = position;
                [self _updateDistance];
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
        tableCell.address.text = self.address;
        tableCell.name.text = self.name;
        tableCell.image.image = [self.location.isEarlyVoteSite boolValue]
                                 ? [UIImage imageNamed:@"Polling_earlyvoting"]
                                 : [UIImage imageNamed:@"Polling_location"];
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
        return @"...";
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
    if (self.tableCell) {
        _distance = [PollingLocationWrapper getDistanceStringFromA:self.mapOrigin
                                                               toB:self.mapPosition];
        self.tableCell.distance.text = _distance;
    }
}

@end
