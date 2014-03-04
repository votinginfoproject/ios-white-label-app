//
//  UserAddress+API.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/3/14.
//  
//

#import "UserAddress+API.h"

#import "VIPError.h"

@implementation UserAddress (API)

+ (UserAddress*)getUnique:(NSString *)address
{
    UserAddress* userAddress = nil;
    if (address && [address length] > 0) {
        userAddress = [UserAddress MR_findFirstByAttribute:@"address" withValue:address];
        if (!userAddress) {
            userAddress = [UserAddress MR_createEntity];
            userAddress.address = address;
        }
        userAddress.lastUsed = [NSDate date];
    }
    return userAddress;
}

- (void)geocode:(void (^)(CLLocationCoordinate2D, NSError *))resultsBlock
{
    double lat = [self.latitude doubleValue];
    double lon = [self.longitude doubleValue];
    if (lat > UA_MIN_LAT && lon > UA_MIN_LON) {
        CLLocationCoordinate2D position = CLLocationCoordinate2DMake(lat, lon);
        resultsBlock(position, nil);
        return;
    }

    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:self.address
                 completionHandler:^(NSArray* placemarks, NSError *error) {
                     CLLocationCoordinate2D position = CLLocationCoordinate2DMake(UA_MIN_LAT, UA_MIN_LON);
                     if (error) {
                         resultsBlock(position, error);
                         return;
                     }
                     if ([placemarks count] == 0) {
                         NSError *geocoderError = [VIPError errorWithCode:VIPGeocoderError];
                         resultsBlock(position, geocoderError);
                     }

                     CLPlacemark *placemark = placemarks[0];
                     double lat = placemark.location.coordinate.latitude;
                     double lon = placemark.location.coordinate.longitude;
                     position.latitude = lat;
                     position.longitude = lon;
                     resultsBlock(position, nil);
                 }];
}

- (BOOL) hasAddress
{
    return (self.address && [self.address length] > 0);
}

@end
