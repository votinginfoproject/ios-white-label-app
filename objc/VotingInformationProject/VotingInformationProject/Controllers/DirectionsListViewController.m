//
//  DirectionsListViewController.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 4/10/14.
//

#import "DirectionsListViewController.h"

#import "NSURL+WithParams.h"
#import "UILabel+HTML.h"

#import "AppSettings.h"
#import "GDDirectionsService.h"
#import "VIPUserDefaultsKeys.h"
#import "VIPColor.h"
#import "VIPEmptyTableViewDataSource.h"

#define AS_APPLEMAPS_INDEX 0
#define AS_GOOGLEMAPS_INDEX 1
#define AS_CANCEL_INDEX 2

@interface DirectionsListViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *directionsTypeControl;
@property (strong, nonatomic) VIPEmptyTableViewDataSource *emptyDataSource;
@property (strong, nonatomic) NSArray *directions;
@property (strong, nonatomic) NSDictionary* json;

@property (assign, nonatomic) kGDDirectionsType transitMode;
@end

@implementation DirectionsListViewController

const NSUInteger VIP_DIRECTIONS_TABLECELL_HEIGHT = 64;

- (void)setTransitMode:(kGDDirectionsType)transitMode
{
    _transitMode = transitMode;
    self.directionsTypeControl.selectedSegmentIndex = transitMode;
    [self requestDirectionsWithMode:(kGDDirectionsType)transitMode];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIColor *navBarBGColor = [VIPColor navBarBackgroundColor];
    self.navigationController.navigationBar.barTintColor = navBarBGColor;
    self.tableView.delegate = self;
    self.json = nil;

    self.emptyDataSource = [[VIPEmptyTableViewDataSource alloc]
                            initWithEmptyMessage:NSLocalizedString(@"No Directions Available", @"String displayed on Directions list error")];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    NSInteger directionsType = [[NSUserDefaults standardUserDefaults]
                                integerForKey:USER_DEFAULTS_DIRECTIONS_TYPE_KEY];
    self.transitMode = directionsType;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSUserDefaults standardUserDefaults] setInteger:self.transitMode
                                               forKey:USER_DEFAULTS_DIRECTIONS_TYPE_KEY];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (id<UITableViewDataSource>)configureDataSource
{
    return ([self.directions count] > 0) ? self : self.emptyDataSource;
}

- (void) requestDirectionsWithMode:(kGDDirectionsType)mode
{

    GDDirectionsService *directionsService = [[GDDirectionsService alloc] init];

    NSInteger epoch = floor([[NSDate date] timeIntervalSince1970]);
    NSDictionary *gdOptions = @{@"sensor": @"true",
                                @"key": [[AppSettings settings] valueForKey:@"GoogleDirectionsAPIKey"],
                                @"mode": [GDDirectionsService directionsTypeToString:mode],
                                @"departure_time": [@(epoch) stringValue],
                                @"origin": self.sourceAddress,
                                @"destination": self.destinationAddress};
    NSLog(@"GD Options: %@", gdOptions);

    [directionsService directionsQuery:gdOptions resultsBlock:^(NSDictionary *json, NSError *error) {
        [self displayDirections:json];
    }];
}

- (void) displayDirections:(NSDictionary*)json
{
    self.directions = @[];
    self.json = nil;
    // cache the last request
    if (![json[@"status"] isEqualToString:@"OK"]) {
        NSLog(@"Directions API Error: %@", json[@"status"]);
    } else {
        @try {
            NSDictionary* tripLeg = json[@"routes"][0][@"legs"][0];
            self.directions = tripLeg[@"steps"];
            self.json = json;
        } @catch (NSException* e) {
            NSLog(@"Error loading json: %@", e);
        }
    }
    self.tableView.dataSource = [self configureDataSource];
    [self.tableView reloadData];
}

- (IBAction)cancel:(id)sender {
    [self.delegate directionsListViewControllerDidClose:self withDirectionsJson:self.json];
}

- (IBAction)action:(id)sender {
    [self openDirectionsActionSheet];
}

#pragma mark - TableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ([self.directions count] > 0) ? VIP_DIRECTIONS_TABLECELL_HEIGHT : VIP_EMPTY_TABLECELL_HEIGHT;
}

#pragma mark - TableView datasource

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"DirectionsCell";

    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier
                                                                 forIndexPath:indexPath];
    NSDictionary *directionsStep = (NSDictionary*)self.directions[indexPath.row];
    [cell.textLabel setHtmlText:directionsStep[@"html_instructions"]
                 withAttributes:@{
                                  NSForegroundColorAttributeName: [VIPColor primaryTextColor],
                                  NSFontAttributeName: [UIFont systemFontOfSize:15]
                                  }];

    NSString *distanceText = directionsStep[@"distance"][@"text"];
    NSString *durationText = directionsStep[@"duration"][@"text"];
    NSString *separator = @" -- ";
    NSString *detailText = [[distanceText stringByAppendingString:separator]
                            stringByAppendingString:durationText];
    cell.detailTextLabel.text = detailText;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.directions count];
};

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma mark - ActionSheet

/**
 *  Display an ActionSheet to allow the user to get directions
 *  when either polling location map marker or list entry is tapped
 *
 *  @param pollingLocationIndex the index of the polling location cell
 */
- (void)openDirectionsActionSheet
{
    NSString *openInMaps = NSLocalizedString(@"Open Directions in Maps",
                                             @"Title in window to get directions when marker's pop-up gets clicked");
    NSString *openInGoogleMaps = NSLocalizedString(@"Open in Google Maps",
                                                 @"Title for the action sheet Open in Google Maps item");
    NSString *openInAppleMaps = NSLocalizedString(@"Open in Apple Maps",
                                                 @"Title for the action sheet Open in Apple Maps item");
    NSString *cancelButtonTitle = NSLocalizedString(@"Cancel", @"Title for a Cancel button");

    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:openInMaps
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];

    NSMutableArray *buttons = [[NSMutableArray alloc] initWithCapacity:2];
    [buttons addObject:openInAppleMaps];
    NSURL *googleMapsURL = [self makeGoogleMapsURL];
    BOOL canOpenGoogleMaps = [[UIApplication sharedApplication] canOpenURL:googleMapsURL];
    if (canOpenGoogleMaps) {
        [buttons addObject:openInGoogleMaps];
    }
    [buttons addObject:cancelButtonTitle];
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    for (NSString *buttonTitle in buttons) {
        [actionSheet addButtonWithTitle:buttonTitle];
    }
    actionSheet.cancelButtonIndex = [buttons count] - 1;

    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
    NSURL* url = nil;
    if (buttonIndex == AS_APPLEMAPS_INDEX) {
        url = [self makeAppleMapsURL];
    } else {
        url = [self makeGoogleMapsURL];
    }
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    } else {
        NSLog(@"actionSheet clickedButtonAtIndex: - Cannot open url %@ in Maps", url);
    }
}

#pragma mark - UISegmentedControl

- (IBAction)onDirectionsTypeSelected:(id)sender {
    if (![sender isKindOfClass:[UISegmentedControl class]]) {
        return;
    }
    UISegmentedControl *directionsControl = (UISegmentedControl*)sender;
    self.transitMode = directionsControl.selectedSegmentIndex;
}

- (NSURL*)makeAppleMapsURL
{
    // The Apple Maps URL Scheme does not currently support passing a transit mode
    //  :( -- https://developer.apple.com/library/ios/featuredarticles/iPhoneURLScheme_Reference/MapLinks/MapLinks.html
    static NSString *appleMapsUrl = @"http://maps.apple.com/";
    return [NSURL URLFromString:appleMapsUrl withParams:@{@"saddr": self.sourceAddress,
                                                          @"daddr": self.destinationAddress}];
}

- (NSURL*)makeGoogleMapsURL
{
    static NSString *googleMapsUrl = @"comgooglemaps://=%@&directionsmode=%@";
    NSString *directionsMode = [GDDirectionsService directionsTypeToString:self.transitMode];
    return [NSURL URLFromString:googleMapsUrl withParams:@{@"saddr": self.sourceAddress,
                                                           @"daddr": self.destinationAddress,
                                                           @"directionsmode": directionsMode}];
}

@end
