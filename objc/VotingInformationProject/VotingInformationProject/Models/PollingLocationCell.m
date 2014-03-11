//
//  PollingLocationCell.m
//  VotingInformationProject
//
//  Created by Bennet Huber on 3/10/14.
//

#import "PollingLocationCell.h"
#import "VIPAddress.h"
#import "VIPAddress+API.h"

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
    self.address.text = [location.address toABAddressString:NO];
    self.distance.text = [PollingLocationCell getDistanceStringFromA:origin
                                                                 toB:position];
    self.name.text = location.name.length > 0 ? location.name : location.address.locationName;
}

- (PollingLocation*)getLocation
{
    return _location;
}

+ (NSString*)getDistanceStringFromA:(CLLocationCoordinate2D)a toB:(CLLocationCoordinate2D)b
{
    // FIXME: Make this actually return values
    return @"0.0mi";
    CLLocation *x = [[CLLocation alloc] initWithLatitude:a.latitude longitude:a.longitude];
    CLLocation *y = [[CLLocation alloc] initWithLatitude:b.latitude longitude:b.longitude];
    CLLocationDistance distance = fabs([x distanceFromLocation:y]);     // Meters
    // TODO: flexible unit conversion?
    // meters * (100 cm / meter) * (1 inch / 2.54 cm) * (1 ft / 12 inch) * (1 mile / 5280')
    distance = distance * 100 / 2.54 / 12 / 5280;
    return [NSString stringWithFormat:@"%1.1fmi", distance];
}

@end
