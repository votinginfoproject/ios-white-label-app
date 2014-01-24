//
//  NearbyPollingViewController.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 1/22/14.
//  Copyright (c) 2014 Bennet Huber. All rights reserved.
//

#import "NearbyPollingViewController.h"

@interface NearbyPollingViewController ()
@property (strong, nonatomic) GMSMapView * mapView;
@end

@implementation NearbyPollingViewController

NSUserDefaults *_userDefaults;
NSString *_address;

- (void)viewDidLoad
{
    [super viewDidLoad];

    _userDefaults = [NSUserDefaults standardUserDefaults];
    double latitude = [_userDefaults doubleForKey:USER_DEFAULTS_LATITUDE_KEY];
    double longitude = [_userDefaults doubleForKey:USER_DEFAULTS_LONGITUDE_KEY];
    
    // Set map view and display
    double defaultLatitude = 39.9522;
    double defaultLongitude = -75.1639;

    if (!latitude) {
        latitude = defaultLatitude;
    }
    if (!longitude) {
        longitude = defaultLongitude;
    }
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:latitude
                                                            longitude:longitude
                                                                 zoom:13];
    self.mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    self.mapView.myLocationEnabled = YES;
    self.view = self.mapView;
    
    _address = [_userDefaults objectForKey:USER_DEFAULTS_STORED_ADDRESS];
    [self geocode:_address];
};

- (void) geocode:(NSString *)address
{
    if (_address) {
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder geocodeAddressString:_address
                     completionHandler:^(NSArray* placemarks, NSError* error){
            for (CLPlacemark* placemark in placemarks)
            {
                [self setPlacemark:placemark andAnimate:YES];
            }
        }];
        
    }
}

- (void) setPlacemark:(CLPlacemark *)placemark
              andAnimate: (BOOL) animate {
    // Process the placemark.
    double latitude = placemark.location.coordinate.latitude;
    double longitude = placemark.location.coordinate.longitude;
    [_userDefaults setDouble:latitude forKey:USER_DEFAULTS_LATITUDE_KEY];
    [_userDefaults setDouble:longitude forKey:USER_DEFAULTS_LONGITUDE_KEY];
    
    // Creates a marker at the placemark location
    GMSMarker *marker = [[GMSMarker alloc] init];
    CLLocationCoordinate2D position = CLLocationCoordinate2DMake(latitude, longitude);
    marker.position = position;
    marker.title = _address;
    marker.snippet = _address;
    marker.map = self.mapView;
   
    if (animate) {
        [self.mapView animateToLocation:position];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
