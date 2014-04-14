//
//  NearbyPollingViewController.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 1/22/14.
//  
//

#import "NearbyPollingViewController.h"

#import "UIImage+Scale.h"

#import "AppSettings.h"
#import "GDDirectionsService.h"
#import "PollingLocationCell.h"
#import "PollingLocationWrapper.h"
#import "VIPColor.h"
#import "VIPEmptyTableViewDataSource.h"
#import "VIPTabBarController.h"
#import "VIPUserDefaultsKeys.h"

#define AS_DIRECTIONS_TO_INDEX 0
#define AS_DIRECTIONS_FROM_INDEX 1
#define AS_DIRECTIONS_CANCEL 2

#define DIRECTIONS_STROKEWIDTH 6

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

@property (strong, nonatomic) GMSPolyline *directionsPolyline;

// Identifies the type of view currently displayed (map or list)
// Can be either MAP_VIEW or LIST_VIEW
@property (assign, nonatomic) NSUInteger currentView;

@property (strong, nonatomic) VIPEmptyTableViewDataSource *emptyDataSource;

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
                if (error) {
                    NSLog(@"Error encountered for marker %@: %@", sender.name, error);
                } else {
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
    NSString *snippetDirections = NSLocalizedString(@"Get Directions", @"String noting that the map infowindow can display directions on tap");
    marker.snippet = [[snippet stringByAppendingString:@"\n\n"] stringByAppendingString:snippetDirections];

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

    self.screenName = @"Nearby Polling Screen";
    self.mapView.delegate = self;
    
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

#pragma mark - GMSMapView delegate

/*
- (UIView*)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker
{
    // TODO: Implement this method to return a custom view with styled background and
    //          a more obvious "Get Directions" link
    static NSUInteger infoWindowWidth = 300;
    static NSUInteger infoWindowHeight = 80;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, infoWindowWidth, infoWindowHeight)];
    view.autoresizesSubviews = UIViewAutoresizingFlexibleHeight;
    view.opaque = YES;
    [view setBackgroundColor:[UIColor whiteColor]];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, -30, infoWindowWidth, infoWindowHeight)];
    titleLabel.text = marker.title;

    UILabel *snippetLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, -10, infoWindowWidth, infoWindowHeight)];
    snippetLabel.lineBreakMode = NSLineBreakByWordWrapping;
    snippetLabel.numberOfLines = 0;
    snippetLabel.font = [UIFont systemFontOfSize:12];
    UIColor *markerTextColor = [VIPColor navBarBackgroundColor];
    NSDictionary *markerTextAttributes = @{NSForegroundColorAttributeName: markerTextColor};
    NSAttributedString *snippet = [[NSAttributedString alloc] initWithString:marker.snippet
                                                                  attributes:markerTextAttributes];
    snippetLabel.attributedText = snippet;

    [view addSubview:titleLabel];
    [view addSubview:snippetLabel];
    return view;
}
*/

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

    [self performSegueWithIdentifier:@"DirectionsViewSegue" sender:self.cells[index]];
}

/**
 *  Draw GMSPolyline on map using json from a Google Directions API request
 *
 *  @param json NSDictionary of the json response from the Google Directions API
 */
- (void)addDirectionsToMap:(NSDictionary*)json
{
    if (!json) {
        return;
    }
    NSDictionary *routes = [json objectForKey:@"routes"][0];

    NSDictionary *route = [routes objectForKey:@"overview_polyline"];
    NSString *overview_route = [route objectForKey:@"points"];
    GMSPath *path = [GMSPath pathFromEncodedPath:overview_route];
    if (self.directionsPolyline && self.directionsPolyline.map) {
        self.directionsPolyline.map = nil;
    }
    self.directionsPolyline = [GMSPolyline polylineWithPath:path];
    self.directionsPolyline.strokeWidth = DIRECTIONS_STROKEWIDTH;
    self.directionsPolyline.map = self.mapView;
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
    PollingLocationWrapper *cell = (PollingLocationWrapper*)[self.cells objectAtIndex:indexPath.item];
    NSString *cellIdentifier = @"PollingLocationCell";
    cell.tableCell = (PollingLocationCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    return cell.tableCell;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ([self.cells count] > 0) ? VIP_POLLING_TABLECELL_HEIGHT : VIP_EMPTY_TABLECELL_HEIGHT;
}

#pragma mark - Segues
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"DirectionsViewSegue"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        DirectionsListViewController *directionsListVC = navigationController.viewControllers[0];
        directionsListVC.delegate = self;

        PollingLocationWrapper *plWrapper = nil;
        if ([sender isKindOfClass:[PollingLocationWrapper class]]) {
            plWrapper = sender;
            directionsListVC.destinationAddress = [plWrapper.location.address toABAddressString:YES];
        } else if ([sender isKindOfClass:[UITableViewCell class]]) {
            PollingLocationCell *cell = (PollingLocationCell*)sender;
            plWrapper = cell.owner;
        }

        directionsListVC.destinationAddress = [plWrapper.location.address toABAddressString:YES];
        directionsListVC.sourceAddress = self.userAddress.address;
    }
}

#pragma mark - DirectionsListViewControllerDelegate
- (void)directionsListViewControllerDidClose:(DirectionsListViewController *)controller withDirectionsJson:(NSDictionary *)json
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self addDirectionsToMap:json];
}

@end
