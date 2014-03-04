//
//  NearbyPollingViewController.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 1/22/14.
//  
//

#import "NearbyPollingViewController.h"
#import "VIPTabBarController.h"

#define AS_DIRECTIONS_TO_INDEX 0
#define AS_DIRECTIONS_FROM_INDEX 1

@interface NearbyPollingViewController ()

@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *siteFilter;
// TODO: Cache markers and reuse
@property (strong, nonatomic) NSMutableArray *markers;
@property (strong, nonatomic) UserAddress *userAddress;

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
    self.userAddress = userAddress;

    // Set map view and display
    double latitude = [userAddress.latitude doubleValue];
    double longitude = [userAddress.longitude doubleValue];
    double zoom = 15;
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:latitude
                                                            longitude:longitude
                                                                 zoom:zoom];

    // Set listener for segmented control
    self.siteFilter.selectedSegmentIndex = VIPPollingLocationTypeAll;
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

/**
 *  Update the UI
 *
 *  Redraws all markers and gets the geocoded location for each PollingLocation address
 */
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
                             marker.userData = location.address;
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

/**
 *  Display an ActionSheet to allow the user to get directions when the marker
 *  infoWindow is tapped
 *
 *  @param mapView mapView
 *  @param marker  The marker that had its infowindow tapped
 */
- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker
{
    NSUInteger index = [self.markers indexOfObject:marker];
    if (index == NSNotFound) {
        return;
    }

    NSString *openInMaps = NSLocalizedString(@"Open in Maps", nil);
    NSString *directionsTo = NSLocalizedString(@"Directions To Here", nil);
    NSString *directionsFrom = NSLocalizedString(@"Directions From Here", nil);
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:openInMaps
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:directionsTo, directionsFrom, nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    actionSheet.tag = index;
    [actionSheet showInView:self.view];
}

#pragma mark - ActionSheet Delegate

/**
 *  Open links in maps app on response from ActionSheet
 *
 *  @param actionSheet The ActionSheet sending this message, should have tag set to index of
 *                      marker that was originally clicked in actionSheet.tag
 *  @param buttonIndex Button that was clicked, 0|1.
 *
 *  Displays a UIAlertView if the generated url cannot be opened in Apple Maps
 */
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:NSLocalizedString(@"Sorry, we are unable to get directions for this location.", nil)
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                          otherButtonTitles:nil];

    NSString *mapsRootUrl = @"http://maps.apple.com/?saddr=%@&daddr=%@";
    GMSMarker *marker = nil;
    @try {
        marker = (GMSMarker*)self.markers[actionSheet.tag];
    } @catch (NSException *e) {
        [alert show];
        return;
    }
    VIPAddress *markerAddress = (VIPAddress*)marker.userData;
    NSURL *url = nil;
    NSString *userAddressString = [NSString stringWithFormat:@"%@,%@",
                                   self.userAddress.latitude,
                                   self.userAddress.longitude];
    NSString *markerAddressString = [markerAddress toABAddressString:NO];
    NSString *saddr, *daddr = nil;
    switch (buttonIndex) {
        case AS_DIRECTIONS_TO_INDEX: {
            saddr = userAddressString;
            daddr = markerAddressString;
            break;
        }
        case AS_DIRECTIONS_FROM_INDEX: {
            saddr = markerAddressString;
            daddr = userAddressString;
            break;
        }
    }
    NSString *urlString = [NSString stringWithFormat:mapsRootUrl, saddr, daddr];
    url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    } else {
        [alert show];
    }
}

@end
