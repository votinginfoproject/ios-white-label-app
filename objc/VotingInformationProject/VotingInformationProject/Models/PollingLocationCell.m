//
//  PollingLocationCell.m
//  VotingInformationProject
//
//  Created by Bennet Huber on 3/10/14.
//

#import "PollingLocationCell.h"
#import "VIPAddress.h"

@implementation PollingLocationCell

PollingLocation* _location;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
    // TODO: switch to map view, zoom to selected location?
}

- (void)updateLocation:(PollingLocation *)location withPosition:(CLLocationCoordinate2D)position andWithOrigin:(CLLocationCoordinate2D)origin
{
    // TODO: update distance when geocoding completes
    // position is not necessarily set to final value when this function is called
    _location = location;
    self.origin = origin;
    self.position = position;
    self.address.text = [PollingLocationCell getAddressText:location];
    self.distance.text = [PollingLocationCell getDistanceStringFromA:origin
                                                                 toB:position];
    self.name.text = location.name.length > 0 ? location.name : location.address.locationName;
}

- (PollingLocation*)getLocation
{
    return _location;
}

+ (NSString*)getAddressText:(PollingLocation* )location
{
    if (location == nil || location.address == nil) {
        return @"";
    }

    VIPAddress* address = location.address;
    NSMutableString *sb = [NSMutableString stringWithCapacity:128];
    [sb appendString:address.line1];

    if (address.line2.length != 0) {
        [sb appendFormat:@", %@", address.line2];
    }

    if (address.line3.length != 0) {
        [sb appendFormat:@", %@", address.line3];
    }

    if (address.city.length != 0) {
        [sb appendFormat:@", %@", address.city];
    }

    if (address.state.length != 0) {
        [sb appendFormat:@", %@", address.state];
    }

    if (address.zip.length != 0) {
        [sb appendFormat:@", %@", address.zip];
    }

    return sb;
}

+ (NSString*)getDistanceStringFromA:(CLLocationCoordinate2D)a toB:(CLLocationCoordinate2D)b
{
    CLLocation *x = [[CLLocation alloc] initWithLatitude:a.latitude longitude:a.longitude];
    CLLocation *y = [[CLLocation alloc] initWithLatitude:b.latitude longitude:b.longitude];
    CLLocationDistance distance = fabs([x distanceFromLocation:y]);     // Meters
    // TODO: flexible unit conversion?
    // meters * (100 cm / meter) * (1 inch / 2.54 cm) * (1 ft / 12 inch) * (1 mile / 5280')
    distance = distance * 100 / 2.54 / 12 / 5280;
    return [NSString stringWithFormat:@"%1.1fmi", distance];
}

@end
