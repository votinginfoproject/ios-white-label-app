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
#import "PollingLocationCell.h"

#define AS_DIRECTIONS_TO_INDEX 0
#define AS_DIRECTIONS_FROM_INDEX 1

@interface NearbyPollingViewController ()

@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (weak, nonatomic) IBOutlet UITableView *listView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *siteFilter;
@property (strong, nonatomic) NSMutableArray *markers;
@property (strong, nonatomic) UIBarButtonItem *ourRightBarButtonItem;
@property (strong, nonatomic) UserAddress *userAddress;

@end


@implementation NearbyPollingViewController {
    NSManagedObjectContext *_moc;
}

@synthesize markers = _markers;

// Map/List view switcher.  Assigned to self.tabBarController.navigationItem.rightBarButtonItem
@synthesize ourRightBarButtonItem = _ourRightBarButtonItem;

// Identifies the type of view currently displayed (map or list)
// Can ve either MAP_VIEW or LIST_VIEW
int _currentView = 0;
static const int MAP_VIEW = 0;
static const int LIST_VIEW = 1;

// Original value of self.tabBarController.navigationItem.rightBarButtonItem
UIBarButtonItem *_oldRightBarButtonItem;


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

- (UIBarButtonItem*)ourRightBarButtonItem
{
    if (_ourRightBarButtonItem == nil) {
        _ourRightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"List" style:UIBarButtonItemStyleBordered target:self action:@selector(onViewSwitcherClicked:)];
    }
    return _ourRightBarButtonItem;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mapView.delegate = self;
    
    _currentView = LIST_VIEW;
    [self onViewSwitcherClicked:nil];

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
    _oldRightBarButtonItem = self.tabBarController.navigationItem.rightBarButtonItem;
    self.tabBarController.navigationItem.rightBarButtonItem = self.ourRightBarButtonItem;
}

- (void) viewWillDisappear:(BOOL)animated
{
    self.tabBarController.navigationItem.rightBarButtonItem = _oldRightBarButtonItem;
}

/**
 *  Update the UI
 *
 *  Redraws all markers and gets the geocoded location for each PollingLocation address
 */
- (void) updateUI
{
    [self updateMap];
    if (_currentView == LIST_VIEW) {
        [self.listView reloadData];
    }
}

- (void) updateMap
{
    self.markers = nil;
    // This is so if we have geocode requests in flight and fire updateMap again the old requests
    // don't overwrite data in the new array.
    NSMutableArray *newMarkers = [[NSMutableArray alloc] init];
    self.markers = newMarkers;

    for (PollingLocation *location in self.locations) {
        [location.address geocode:^(CLLocationCoordinate2D position, NSError *error) {
            if (!error) {
                GMSMarker *marker = [self setPlacemark:position
                                             withTitle:location.name
                                            andSnippet:[location.address toABAddressString:NO]];
                marker.map = self.mapView;
                marker.userData = location.address;
                [newMarkers addObject:marker];
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

- (void)onViewSwitcherClicked:(id)sender
{
    UIView *currentView;                    // View we're currently looking at
    UIView *nextView;                       // View we're switching to
    UIViewAnimationTransition transition;   // Flip left/right

    if (_currentView == MAP_VIEW) {
        currentView = self.mapView;
        nextView = self.listView;
        self.ourRightBarButtonItem.title = NSLocalizedString(@"Map", @"Nav button label");
        transition = UIViewAnimationTransitionFlipFromRight;
        _currentView = LIST_VIEW;
    }
    else {
        currentView = self.listView;
        nextView = self.mapView;
        self.ourRightBarButtonItem.title = NSLocalizedString(@"List", @"Nav button label");
        transition = UIViewAnimationTransitionFlipFromLeft;
        _currentView = MAP_VIEW;
    }

    [self updateUI];

    [UIView beginAnimations:@"View Flip" context:nil];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];

    
    [UIView setAnimationTransition: transition forView:self.contentView cache:YES];
    currentView.hidden = YES;
    nextView.hidden = NO;
    
    [UIView commitAnimations];
}

- (GMSMarker*) setPlacemark:(CLLocationCoordinate2D)position
                  withTitle:(NSString*)title
                 andSnippet:(NSString*)snippet
{
    // Creates a marker at the placemark location
    GMSMarker *marker = [GMSMarker markerWithPosition:position];
    marker.title = title;
    marker.snippet = snippet;

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


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.locations.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"PollingLocationCell";
    PollingLocationCell *cell = (PollingLocationCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    PollingLocation *location = (PollingLocation*)[self.locations objectAtIndex:indexPath.row];

    // TODO: This throws an exception because we get here before the geocoding requests complete
    // CLLocationCoordinate2D position = ((GMSMarker*)self.markers[indexPath.row]).position;
    CLLocationCoordinate2D position = CLLocationCoordinate2DMake(0, 0);

    // TODO: get real origin
    CLLocationCoordinate2D origin = self.userAddress.position;
    [cell updateLocation:location withPosition:position andWithOrigin:origin];
    return cell;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return nil;
}



@end
