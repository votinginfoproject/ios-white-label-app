//
//  VIPAddress+API.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/5/14.
//  
//

#import <AddressBookUI/AddressBookUI.h>
#import <AddressBook/AddressBook.h>
#import "VIPAddress+API.h"

@implementation VIPAddress (API)

- (NSString*)toABAddressString:(BOOL)withNewlines
{
    // TODO: Allow user to set country code in settings.plist
    //NSString *street = [NSString stringWithFormat:@"%@ %@ %@", self.line1, self.line2, self.line3];
    NSString *line1 = self.line1 ? self.line1 : @"";
    NSString *city = self.city ? self.city : @"";
    NSString *state = self.state ? self.state : @"";
    NSString *zip = self.zip ? self.zip : @"";
    NSDictionary *addressDict = @{
                                  (NSString*)kABPersonAddressStreetKey: line1,
                                  (NSString*)kABPersonAddressCityKey: city,
                                  (NSString*)kABPersonAddressStateKey: state,
                                  (NSString*)kABPersonAddressZIPKey: zip,
                                  (NSString*)kABPersonAddressCountryCodeKey: @"us"};
    NSString *address = ABCreateStringWithAddressDictionary(addressDict, YES);
    if (!withNewlines) {
        address = [address stringByReplacingOccurrencesOfString:@"\n" withString:@", "];
    }
    return address;
}

- (void)geocode:(void (^)(CLLocationCoordinate2D, NSError *))resultsBlock
{
    double lat = [self.latitude doubleValue];
    double lon = [self.longitude doubleValue];
    if (self.latitude && self.longitude && lat > VA_MIN_LAT && lon > VA_MIN_LON) {
        CLLocationCoordinate2D position = CLLocationCoordinate2DMake(lat, lon);
        resultsBlock(position, nil);
        return;
    }

    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:[self toABAddressString:NO]
                 completionHandler:^(NSArray* placemarks, NSError *error) {
                     CLLocationCoordinate2D position = CLLocationCoordinate2DMake(VA_MIN_LAT, VA_MIN_LON);
                     if (error) {
                         resultsBlock(position, error);
                         return;
                     }
                     if ([placemarks count] == 0) {
                         NSError *geocoderError = [VIPError errorWithCode:VIPError.GeocoderError];
                         resultsBlock(position, geocoderError);
                         return;
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
