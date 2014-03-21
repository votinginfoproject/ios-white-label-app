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
#import "PollingLocationWrapper.h"
#import "VIPEmptyTableViewDataSource.h"
#import "UIImage+Scale.h"

#define AS_DIRECTIONS_TO_INDEX 0
#define AS_DIRECTIONS_FROM_INDEX 1
#define AS_DIRECTIONS_CANCEL 2

@interface NearbyPollingViewController ()

@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (weak, nonatomic) IBOutlet UITableView *listView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *siteFilter;

// Original value of self.tabBarController.navigationItem.rightBarButtonItem
@property (strong, nonatomic) UIBarButtonItem *originalRightBarButtonItem;

// Map/List view switcher.  Assigned to self.tabBarController.navigationItem.rightBarButtonItem
@property (strong, nonatomic) UIBarButtonItem *ourRightBarButtonItem;

@property (strong, nonatomic) UserAddress *userAddress;

// Identifies the type of view currently displayed (map or list)
// Can be either MAP_VIEW or LIST_VIEW
@property (assign, nonatomic) NSUInteger currentView;

@property (strong, nonatomic) VIPEmptyTableViewDataSource *emptyDataSource;

/** Open action sheet to prompt for getting directions from either map or list */
- (void)openDirectionsActionSheet:(NSInteger)pollingLocationIndex;

@end


@implementation NearbyPollingViewController {
    NSManagedObjectContext *_moc;
    GMSMarker *_userAddressMarker;
    NSMutableArray *_cells;
}

static const int MAP_VIEW = 0;
static const int LIST_VIEW = 1;

const NSUInteger VIP_POLLING_TABLECELL_HEIGHT = 76;

- (NSMutableArray*)cells
{
    if (!_cells) {
        _cells = [[NSMutableArray alloc] init];
    }
    return _cells;
}

- (void)setCells:(NSMutableArray *)cells
{
    if (!cells) {
        for (PollingLocationWrapper *cell in _cells) {
            // Releases all cell resources, including map markers and table cell views
            [cell reset];
        }
    }
    _cells = cells;
    [self updateUI];
}

- (void)setCellsWithLocations:(NSArray *)locations
{
    // Preinit to reduce mapping overhead
    // Also scale the images to the proper size
    UIImage *earlyVoting = [UIImage imageWithImage:[UIImage imageNamed:@"Polling_earlyvoting"] scaledToSize:CGSizeMake(25, 38)];
    UIImage *polling = [UIImage imageWithImage:[UIImage imageNamed:@"Polling_location"] scaledToSize:CGSizeMake(25, 38)];

    self.cells = nil;
    NSMutableArray *newCells = [[NSMutableArray alloc] initWithCapacity:[locations count]];
    for (PollingLocation *location in locations) {
        PollingLocationWrapper *cell = [[PollingLocationWrapper alloc] initWithLocation:location andGeocodeHandler:^void(PollingLocationWrapper *sender, NSError *error) {
                if (!error) {
                    GMSMarker *marker = [self setPlacemark:sender.mapPosition
                                                 withTitle:sender.name
                                                andSnippet:sender.address];
                    if ([location.isEarlyVoteSite boolValue]) {
                        marker.icon = earlyVoting;
                    } else {
                        marker.icon = polling;
                    }
                    marker.map = self.mapView;
                    marker.userData = sender.location.address;
                    sender.marker = marker;
                }
        }];
        if (_userAddressMarker) {
            cell.mapOrigin = _userAddressMarker.position;
        }
        [newCells addObject:cell];
    }
    self.cells = newCells;
}

- (id<UITableViewDataSource>)configureDataSource
{
    return ([self.cells count] > 0) ? self : self.emptyDataSource;
}

/**
 *  Update the UI
 *
 *  Redraws all markers and gets the geocoded location for each PollingLocation address
 */
- (void) updateUI
{
    if (_currentView == LIST_VIEW) {
        self.listView.dataSource = [self configureDataSource];
        [self.listView reloadData];
    }
}

- (void)filterLocations:(id)sender
{
    if ([sender isKindOfClass:[UISegmentedControl class]]) {
        UISegmentedControl *siteFilter = (UISegmentedControl*)sender;
        VIPPollingLocationType type = (VIPPollingLocationType)siteFilter.selectedSegmentIndex;
        [self setEmptyMessage:type];
        [self setCellsWithLocations:[self.election filterPollingLocations:type]];
    }
}

- (void)setEmptyMessage:(VIPPollingLocationType)type
{
    NSString *earlyVoteMessage = NSLocalizedString(@"No Nearby Early Vote Sites",
                                                   @"Text to display if the table view has no early vote sites to display");
    NSString *pollingMessage = NSLocalizedString(@"No Nearby Polling Locations",
                                                 @"Text to display if the table view has no polling locations to display");
    self.emptyDataSource.emptyMessage = (type == VIPPollingLocationTypeEarlyVote)
                                        ? earlyVoteMessage : pollingMessage;
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



- (UIBarButtonItem*)ourRightBarButtonItem
{
    if (_ourRightBarButtonItem == nil) {
        _ourRightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"List"
                                                                  style:UIBarButtonItemStyleBordered
                                                                 target:self
                                                                 action:@selector(onViewSwitcherClicked:)];
    }
    return _ourRightBarButtonItem;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mapView.delegate = self;
    
    _moc = [NSManagedObjectContext MR_contextForCurrentThread];
    self.emptyDataSource = [[VIPEmptyTableViewDataSource alloc] init];
    self.listView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    // Set table view fully transparent
    self.listView.backgroundColor = [UIColor clearColor];
    self.listView.opaque = NO;
    self.listView.backgroundView = nil;
    self.contentView.backgroundColor = [UIColor clearColor];
    self.contentView.opaque = NO;
};

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    VIPTabBarController *tabBarController = (VIPTabBarController*)self.tabBarController;

    tabBarController.title = NSLocalizedString(@"Polling Sites",
                                               @"Label for polling sites tab button");
    self.originalRightBarButtonItem = tabBarController.navigationItem.rightBarButtonItem;
    tabBarController.navigationItem.rightBarButtonItem = self.ourRightBarButtonItem;

    // Set proper view from last known
    _currentView = [[NSUserDefaults standardUserDefaults] integerForKey:USER_DEFAULTS_POLLING_VIEW_KEY];
    [self switchView:_currentView animated:NO];

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
    VIPPollingLocationType type = (VIPPollingLocationType)[[NSUserDefaults standardUserDefaults]
                                   integerForKey:USER_DEFAULTS_SITE_FILTER_KEY];
    self.siteFilter.selectedSegmentIndex = type;
    [self setEmptyMessage:type];
    [self.siteFilter addTarget:self
                        action:@selector(filterLocations:)
              forControlEvents:UIControlEventValueChanged];

    // Initialize Map View
    self.mapView.camera = camera;
    self.mapView.myLocationEnabled = YES;

    [self.userAddress geocode:^(CLLocationCoordinate2D position, NSError *error) {
        if (!error) {
            _userAddressMarker = [GMSMarker markerWithPosition:position];
            _userAddressMarker.title = NSLocalizedString(@"Your Address",
                                                         @"Title for map marker pop-up on user's address");
            _userAddressMarker.snippet = self.userAddress.address;
            _userAddressMarker.icon = [GMSMarker markerImageWithColor:[UIColor greenColor]];
            _userAddressMarker.map = self.mapView;
            for (PollingLocationWrapper *cell in self.cells) {
                cell.mapOrigin = position;
            }
            [self.mapView animateToLocation:position];
        }
    }];

    [self setCellsWithLocations:[self.election filterPollingLocations:type]];
}

- (void) viewWillDisappear:(BOOL)animated
{
    self.tabBarController.navigationItem.rightBarButtonItem = self.originalRightBarButtonItem;
    [[NSUserDefaults standardUserDefaults] setInteger:_currentView
                                               forKey:USER_DEFAULTS_POLLING_VIEW_KEY];
    [[NSUserDefaults standardUserDefaults] setInteger:self.siteFilter.selectedSegmentIndex
                                               forKey:USER_DEFAULTS_SITE_FILTER_KEY];
}



- (void)onViewSwitcherClicked:(id)sender
{
    if (_currentView == MAP_VIEW) {
        [self switchView:LIST_VIEW animated:YES];
    } else if (_currentView == LIST_VIEW) {
        [self switchView:MAP_VIEW animated:YES];
    }
}

/**
 *  Switch Map/List views
 *
 *  @param viewType The view to switch to, either MAP_VIEW or LIST_VIEW
 *  @param animated
 */
- (void)switchView:(NSUInteger)viewType
          animated:(BOOL)animated
{
    UIView *currentView;                    // View we're currently looking at
    UIView *nextView;                       // View we're switching to
    UIViewAnimationTransition transition;   // Flip left/right

    if (viewType == LIST_VIEW) {
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

    if (animated) {
        [UIView beginAnimations:@"View Flip" context:nil];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];


        [UIView setAnimationTransition: transition forView:self.contentView cache:YES];
        currentView.hidden = YES;
        nextView.hidden = NO;

        [UIView commitAnimations];
    } else {
        currentView.hidden = YES;
        nextView.hidden = NO;
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  Display an ActionSheet to allow the user to get directions
 *  when either polling location map marker or list entry is tapped
 *
 *  @param pollingLocationIndex the index of the polling location cell
 */
- (void)openDirectionsActionSheet:(NSInteger)pollingLocationIndex;
{
    NSString *openInMaps = NSLocalizedString(@"Open in Maps",
                                             @"Title in window to get directions when marker's pop-up gets clicked");
    NSString *directionsTo = NSLocalizedString(@"Directions To Here",
                                               @"Label in window for directions destination");
    NSString *directionsFrom = NSLocalizedString(@"Directions From Here",
                                                 @"Label in window for directions origin");
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:openInMaps
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedString(@"Cancel",
                                                                                        @"Label for directions cancel button")
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:directionsTo, directionsFrom, nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    actionSheet.tag = pollingLocationIndex;
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
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
    // Find cell with corresponding marker
    int index = -1;
    int i = 0;
    for (PollingLocationWrapper *cell in self.cells) {
        if ([cell.marker isEqual:marker]) {
            index = i;
            break;
        }
        i++;
    }

    if (index < 0) {
        return;
    }

    [self openDirectionsActionSheet:index];
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
    if (buttonIndex == AS_DIRECTIONS_CANCEL) {
        return;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:NSLocalizedString(@"Sorry, we are unable to get directions for this location.",
                                                                              @"Error message when directions not found")
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"OK",
                                                                              @"Label for button to exit directions window")
                                          otherButtonTitles:nil];

    NSString *mapsRootUrl = @"http://maps.apple.com/?saddr=%@&daddr=%@";
    GMSMarker *marker = nil;

    // Ensure actionSheet.tag is in range
    @try {
        marker = ((PollingLocationWrapper*)self.cells[actionSheet.tag]).marker;
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
    NSString *userAddressString = self.userAddress.address;
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
    NSLog(@"Source Addr: %@, Dest Addr: %@", saddr, daddr);
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
    return self.cells.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PollingLocationWrapper *cell = (PollingLocationWrapper*)[self.cells objectAtIndex:indexPath.row];
    if (!cell.tableCell) {
        NSString *cellIdentifier = @"PollingLocationCell";
        cell.tableCell = (PollingLocationCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    }
    return cell.tableCell;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.cells.count) return;  // do not give directions on empty list item
    [self openDirectionsActionSheet:indexPath.row];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ([self.cells count] > 0) ? VIP_POLLING_TABLECELL_HEIGHT : VIP_EMPTY_TABLECELL_HEIGHT;
}

@end
