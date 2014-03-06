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

@property (strong, nonatomic) IBOutlet GMSMapView *mapView;
@property (strong, nonatomic) IBOutlet UITableView *listView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *viewSwitcher;
@property (weak, nonatomic) IBOutlet UISegmentedControl *siteFilter;
// TODO: Cache markers and reuse
@property (strong, nonatomic) NSMutableArray *markers;
@property (strong, nonatomic) UIBarButtonItem *ourRightBarButtonItem;

@end

@implementation NearbyPollingViewController {
    NSManagedObjectContext *_moc;
}

@synthesize markers = _markers;
@synthesize ourRightBarButtonItem = _ourRightBarButtonItem;

int _currentView = 0;
const int MAP_VIEW = 0;
const int LIST_VIEW = 1;

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

    // Set map view and display
    double latitude = [userAddress.latitude doubleValue];
    double longitude = [userAddress.longitude doubleValue];
    double zoom = 13;
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
    _oldRightBarButtonItem = self.tabBarController.navigationItem.rightBarButtonItem;
    self.tabBarController.navigationItem.rightBarButtonItem = self.ourRightBarButtonItem;
}

- (void) viewWillDisappear:(BOOL)animated
{
    self.tabBarController.navigationItem.rightBarButtonItem = _oldRightBarButtonItem;
}

- (void) viewDidDisappear:(BOOL)animated
{
    
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

- (void)onViewSwitcherClicked:(id)sender
{
    [UIView beginAnimations:@"View Flip" context:nil];
    [UIView setAnimationDuration:1.25];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    UIView *currentView = _currentView == MAP_VIEW ? self.mapView : self.listView;
    UIView *nextView = _currentView == MAP_VIEW ? self.listView : self.mapView;
    UIViewAnimationTransition transition = _currentView == MAP_VIEW ?UIViewAnimationTransitionFlipFromLeft : UIViewAnimationTransitionFlipFromRight;
    
    
    [UIView setAnimationTransition: transition forView:self.contentView cache:YES];
    //[currentView removeFromSuperview];
    //[self.contentView insertSubview: nextView atIndex:0];
    currentView.hidden = YES;
    nextView.hidden = NO;
    _currentView = _currentView == MAP_VIEW ? LIST_VIEW : MAP_VIEW;
    
    [UIView commitAnimations];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    PollingLocation *location = (PollingLocation*)[self.locations objectAtIndex:indexPath.row];
    cell.textLabel.text = location.address.locationName;
    return cell;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Test String";
}

/**
 * @param section Table section returned by the table view
 * @return NSString* cell identifier for the passed section
 */
- (NSString*)cellIdentifierFor:(NSInteger) section
{
    if (section == 0) {
        return @"PollingLocationCell";
    } else if (section == 1) {
        return @"PollingLocationCell";
    }
    return nil;
}


@end
