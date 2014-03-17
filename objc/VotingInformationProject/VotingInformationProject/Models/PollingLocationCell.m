//
//  PollingLocationCell.m
//  VotingInformationProject
//
//  Created by Bennet Huber on 3/10/14.
//

#import "PollingLocationCell.h"
#import "VIPAddress.h"
#import "VIPAddress+API.h"

@implementation PollingLocationCell {
    CLLocationCoordinate2D _mapOrigin;
}

const CLLocationCoordinate2D NullCoordinate = {-999, -999};
PollingLocation* _location;

- (void) awakeFromNib
{
    self.mapPosition = NullCoordinate;
    self.mapOrigin = NullCoordinate;

//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
//                                                                          action:@selector(openOnMap:)];
//    [cell.name addGestureRecognizer:tap];
}

- (void) reset
{
    self.location = nil;
    self.marker = nil;
    self.mapPosition = NullCoordinate;
    self.mapOrigin = NullCoordinate;
    self.distance.text = @"...";
    if (self.marker) {
        self.marker.map = nil;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
    if (self.onRowSelected) {
        self.onRowSelected(self);
    }
}

- (void)updateLocation:(PollingLocation *)location withMapOrigin:(CLLocationCoordinate2D)mapOrigin
{
    // TODO: update distance when geocoding completes
    // position is not necessarily set to final value when this function is called
    _location = location;
    self.mapOrigin = mapOrigin;
    self.address.text = [location.address toABAddressString:NO];
    self.name.text = location.name.length > 0 ? location.name : location.address.locationName;
    self.distance.text = @"...";

    [self.location.address geocode:^(CLLocationCoordinate2D position, NSError *error) {
        if (!error) {
            self.mapPosition = position;
            self.distance.text = [PollingLocationCell getDistanceStringFromA:self.mapOrigin
                                                                         toB:position];
        }
        if (self.onGeocodeComplete) {
            [self.onGeocodeComplete self];
        }
    }];
}

- (void)setMapOrigin:(CLLocationCoordinate2D)mapOrigin
{
    _mapOrigin = mapOrigin;
    self.distance.text = [PollingLocationCell getDistanceStringFromA:self.mapOrigin
                                                                 toB:self.mapPosition];
}

- (CLLocationCoordinate2D)mapOrigin
{
    return _mapOrigin;
}

- (PollingLocation*)getLocation
{
    return _location;
}



+ (NSString*)getDistanceStringFromA:(CLLocationCoordinate2D)a toB:(CLLocationCoordinate2D)b
{
    if ((a.latitude == NullCoordinate.latitude && a.longitude == NullCoordinate.longitude) ||
        (b.latitude == NullCoordinate.latitude && b.longitude == NullCoordinate.longitude)) {
        return @"...";
    }
    CLLocation *x = [[CLLocation alloc] initWithLatitude:a.latitude longitude:a.longitude];
    CLLocation *y = [[CLLocation alloc] initWithLatitude:b.latitude longitude:b.longitude];
    CLLocationDistance distance = fabs([x distanceFromLocation:y]);     // Meters
    // TODO: flexible unit conversion?
    // meters * (100 cm / meter) * (1 inch / 2.54 cm) * (1 ft / 12 inch) * (1 mile / 5280')
    distance = distance * 100 / 2.54 / 12 / 5280;
    return [NSString stringWithFormat:@"%1.1fmi", distance];
}

@end
