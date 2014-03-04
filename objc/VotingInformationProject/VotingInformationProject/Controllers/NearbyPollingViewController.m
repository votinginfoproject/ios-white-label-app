//
//  NearbyPollingViewController.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 1/22/14.
//  
//

#import "VIPUserDefaultsKeys.h"
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
    double zoom = 14;
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

    [self.userAddress geocode:^(CLLocationCoordinate2D position, NSError *error) {
        if (!error) {
            GMSMarker *marker = [GMSMarker markerWithPosition:position];
            marker.title = NSLocalizedString(@"Your Address", nil);
            marker.snippet = self.userAddress.address;
            marker.map = self.mapView;
            [self.mapView animateToLocation:position];
        }
    }];
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
        [location.address geocode:^(CLLocationCoordinate2D position, NSError *error) {
            if (!error) {
                GMSMarker *marker = [self setPlacemark:position
                                             withTitle:location.name
                                            andSnippet:[location.address toABAddressString:NO]];
                marker.map = self.mapView;
                marker.userData = location.address;
            }

        }];
    }
    // TODO: Zoom map to locations when all are geocoded
}

- (void)filterLocations:(id)sender
{
    if ([sender isKindOfClass:[UISegmentedControl class]]) {
        UISegmentedControl *siteFilter = (UISegmentedControl*)sender;
        self.locations = [self.election filterPollingLocations:siteFilter.selectedSegmentIndex];
    }
}

- (GMSMarker*) setPlacemark:(CLLocationCoordinate2D)position
                  withTitle:(NSString*)title
                 andSnippet:(NSString*)snippet
{
    // Creates a marker at the placemark location
    GMSMarker *marker = [GMSMarker markerWithPosition:position];
    marker.title = title;
    marker.snippet = snippet;

    [self.markers addObject:marker];

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
 *  @warning Requires GMSMarker.userData to be of type VIPAddress*
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

    // Ensure actionSheet.tag is in range
    @try {
        marker = (GMSMarker*)self.markers[actionSheet.tag];
    } @catch (NSException *e) {
        [alert show];
        NSLog(@"actionSheet clickedButtonAtIndex: - No marker %@ in self.markers", marker.title);
        return;
    }
    // Ensure userData has a VIPAddress in it
    if (![marker.userData isKindOfClass:[VIPAddress class]]) {
        [alert show];
        NSLog(@"actionSheet clickedButtonAtIndex - Marker %@ userData not a VIPAddress", marker.title);
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
        NSLog(@"actionSheet clickedButtonAtIndex: - Cannot open url %@ in Maps", url);
        [alert show];
    }
}

@end
