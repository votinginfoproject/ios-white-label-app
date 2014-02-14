//
//  NearbyPollingViewController.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 1/22/14.
//  
//

#import "NearbyPollingViewController.h"

@interface NearbyPollingViewController ()
@property (strong, nonatomic) GMSMapView * mapView;
@end

@implementation NearbyPollingViewController {
    NSManagedObjectContext *_moc;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    _moc = [NSManagedObjectContext MR_contextForCurrentThread];

    // Set map center to address if it exists
    UserAddress *userAddress = [UserAddress MR_findFirstOrderedByAttribute:@"lastUsed"
                                                 ascending:NO];
    // Set map view and display
    double latitude = [userAddress.latitude doubleValue];
    double longitude = [userAddress.longitude doubleValue];
    double zoom = 13;
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:latitude
                                                            longitude:longitude
                                                                 zoom:zoom];

    // Initialize Map View
    self.mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    self.mapView.myLocationEnabled = YES;
    self.view = self.mapView;

    [self geocode:userAddress andSetPlacemark:YES];
};

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.tabBarController) {
        self.tabBarController.title = NSLocalizedString(@"Polling Sites", nil);
    }
}

- (void) geocode:(UserAddress *)userAddress
 andSetPlacemark:(BOOL) setPlacemark
{
    if (userAddress) {
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder geocodeAddressString:userAddress.address
                     completionHandler:^(NSArray* placemarks, NSError* error){
                         CLPlacemark* placemark = placemarks[0];
                         userAddress.latitude = @(placemark.location.coordinate.latitude);
                         userAddress.longitude = @(placemark.location.coordinate.longitude);
                         [_moc MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
                             NSLog(@"DataStore saved: %d", success);
                         }];
                         
                         if (setPlacemark) {
                             [self setPlacemark:userAddress andAnimate:YES];
                         }
        }];
    }
}

- (void) setPlacemark:(UserAddress *)userAddress
              andAnimate: (BOOL) animate
{
    // Creates a marker at the placemark location
    GMSMarker *marker = [[GMSMarker alloc] init];
    double lat = [userAddress.latitude doubleValue];
    double lon = [userAddress.longitude doubleValue];
    CLLocationCoordinate2D position = CLLocationCoordinate2DMake(lat, lon);
    marker.position = position;
    marker.title = userAddress.address;
    marker.snippet = userAddress.address;
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
