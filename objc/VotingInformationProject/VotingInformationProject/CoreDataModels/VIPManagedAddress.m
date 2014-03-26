//
//  VIPManagedAddress.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 3/4/14.
//

#import "VIPManagedAddress.h"


@implementation VIPManagedAddress

@dynamic latitude;
@dynamic longitude;
@dynamic address;

- (CLLocationCoordinate2D)position
{
    return CLLocationCoordinate2DMake(self.latitude.doubleValue, self.longitude.doubleValue);
}

- (void)geocode:(void (^)(CLLocationCoordinate2D, NSError *))resultsBlock
{
    double lat = [self.latitude doubleValue];
    double lon = [self.longitude doubleValue];
    if (lat > VA_MIN_LAT && lon > VA_MIN_LON) {
        CLLocationCoordinate2D position = CLLocationCoordinate2DMake(lat, lon);
        resultsBlock(position, nil);
        return;
    }

    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:self.address
                 completionHandler:^(NSArray* placemarks, NSError *error) {
                     CLLocationCoordinate2D position = CLLocationCoordinate2DMake(VA_MIN_LAT, VA_MIN_LON);
                     if (error) {
                         resultsBlock(position, error);
                         return;
                     }
                     if ([placemarks count] == 0) {
                         NSError *geocoderError = [VIPError errorWithCode:VIPError.GeocoderError];
                         resultsBlock(position, geocoderError);
                     }

                     CLPlacemark *placemark = placemarks[0];
                     double lat = placemark.location.coordinate.latitude;
                     double lon = placemark.location.coordinate.longitude;
                     self.latitude = [[NSNumber alloc] initWithDouble:lat];
                     self.longitude = [[NSNumber alloc] initWithDouble:lon];
                     position.latitude = lat;
                     position.longitude = lon;
                     resultsBlock(position, nil);
                 }];
}

@end
