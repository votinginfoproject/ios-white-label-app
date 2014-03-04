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
    NSDictionary *addressDict = @{
                                  (NSString*)kABPersonAddressStreetKey: self.line1,
                                  (NSString*)kABPersonAddressCityKey: self.city,
                                  (NSString*)kABPersonAddressStateKey: self.state,
                                  (NSString*)kABPersonAddressZIPKey: self.zip,
                                  (NSString*)kABPersonAddressCountryCodeKey: @"us"};
    NSString *address = ABCreateStringWithAddressDictionary(addressDict, YES);
    if (!withNewlines) {
        address = [address stringByReplacingOccurrencesOfString:@"\n" withString:@", "];
    }
    return address;
}

- (void) geocode:(void (^)(CLLocationCoordinate2D, NSError *))resultsBlock
{
    double lat = [self.latitude doubleValue];
    double lon = [self.longitude doubleValue];
    if (lat > VA_MIN_LAT && lon > VA_MIN_LON) {
        CLLocationCoordinate2D position = CLLocationCoordinate2DMake(lat, lon);
        resultsBlock(position, nil);
        return;
    }

    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    NSString *address = [self toABAddressString:NO];
    [geocoder geocodeAddressString:address
                 completionHandler:^(NSArray* placemarks, NSError *error) {
                     CLLocationCoordinate2D position = CLLocationCoordinate2DMake(VA_MIN_LAT, VA_MIN_LON);
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

@end
