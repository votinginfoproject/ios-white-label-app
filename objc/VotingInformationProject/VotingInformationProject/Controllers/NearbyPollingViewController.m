//
//  NearbyPollingViewController.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 1/22/14.
//  
//

#import "NearbyPollingViewController.h"
#import "VIPTabBarController.h"

@interface NearbyPollingViewController ()

@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *siteFilter;
// TODO: Cache markers and reuse
@property (strong, nonatomic) NSMutableArray *markers;

@end

@implementation NearbyPollingViewController {
    NSManagedObjectContext *_moc;
}

@synthesize markers = _markers;

- (void)setLocations:(NSArray *)locations
{
    _locations = locations;
    [self updateUI];
}

- (NSMutableArray*)markers
{
    if (!_markers) {
        _markers = [[NSMutableArray alloc] init];
    }
    return _markers;
}

- (void)setMarkers:(NSMutableArray *)markers
{
    if (!markers) {
        // If we are clearing the markers array, remove them from the map as well
        for (GMSMarker *marker in _markers) {
            marker.map = nil;
        }
    }
    _markers = markers;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mapView.delegate = self;

    _moc = [NSManagedObjectContext MR_contextForCurrentThread];
    VIPTabBarController *tabBarController = (VIPTabBarController*)self.tabBarController;
    self.election = tabBarController.currentElection;

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

    // Set listener for segmented control
    self.siteFilter.selectedSegmentIndex = kPollingLocationTypeAll;
    [self.siteFilter addTarget:self
                        action:@selector(filterLocations:)
              forControlEvents:UIControlEventValueChanged];

    // Initialize Map View
    self.mapView.camera = camera;
    self.mapView.myLocationEnabled = YES;

    [self geocode:userAddress andSetPlacemark:YES];
    self.locations = [self.election filterPollingLocations:self.siteFilter.selectedSegmentIndex];
};

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.tabBarController.title = NSLocalizedString(@"Polling Sites", nil);
}

- (void) updateUI
{
    self.markers = nil;

    for (PollingLocation *location in self.locations) {
        NSString *address = [location.address toABAddressString:YES];
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder geocodeAddressString:address
                     completionHandler:^(NSArray* placemarks, NSError *error) {
                         if (!error) {
                             CLPlacemark *placemark = placemarks[0];
                             GMSMarker *marker = [self setPlacemark:placemark
                                                          withTitle:location.name
                                                         andAnimate:NO];
                             marker.map = self.mapView;
                             marker.snippet = address;
                             marker.userData = location;
                             [self.markers addObject:marker];
                             
                         }
                     }];
    }

    // TODO: Zoom map to locations when all are geocoded
}

- (void) geocode:(UserAddress *)userAddress
 andSetPlacemark:(BOOL) setPlacemark
{
    if (!userAddress) {
        return;
    }
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
                         // TODO: Distinguish this placemark from the PollingLocation marks
                         GMSMarker * marker = [self setPlacemark:placemark
                                                       withTitle:NSLocalizedString(@"Your Address", nil)
                                                      andAnimate:YES];
                         marker.snippet = userAddress.address;
                         marker.map = self.mapView;
                     }
                 }];
}

- (void)filterLocations:(id)sender
{
    if ([sender isKindOfClass:[UISegmentedControl class]]) {
        UISegmentedControl *siteFilter = (UISegmentedControl*)sender;
        self.locations = [self.election filterPollingLocations:siteFilter.selectedSegmentIndex];
    }
}

- (GMSMarker*) setPlacemark:(CLPlacemark *)placemark
                  withTitle:(NSString*)title
                 andAnimate: (BOOL) animate
{
    // Creates a marker at the placemark location
    GMSMarker *marker = [[GMSMarker alloc] init];
    double lat = placemark.location.coordinate.latitude;
    double lon = placemark.location.coordinate.longitude;
    CLLocationCoordinate2D position = CLLocationCoordinate2DMake(lat, lon);
    marker.position = position;
    marker.title = title;

    if (animate) {
        [self.mapView animateToLocation:position];
    }
    return marker;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - GMSMapView delegate
- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker
{
    // TODO: Segue to modal overlay that displays directions to/from here buttons
}

@end
