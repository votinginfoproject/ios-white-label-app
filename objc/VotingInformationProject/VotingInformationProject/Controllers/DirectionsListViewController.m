//
//  DirectionsListViewController.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 4/10/14.
//  Copyright (c) 2014 Bennet Huber. All rights reserved.
//

#import "DirectionsListViewController.h"

#import "UILabel+HTML.h"

#import "AppSettings.h"
#import "GDDirectionsService.h"
#import "VIPColor.h"

#define AS_APPLEMAPS_INDEX 0
#define AS_GOOGLEMAPS_INDEX 1
#define AS_CANCEL_INDEX 2

@interface DirectionsListViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *directions;
@property (strong, nonatomic) NSDictionary* json;
@end

@implementation DirectionsListViewController

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
    NSLog(@"Directions viewDidLoad");
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    UIColor *navBarBGColor = [VIPColor navBarBackgroundColor];
    self.navigationController.navigationBar.barTintColor = navBarBGColor;
    self.tableView.delegate = self;
    self.json = nil;

    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"Directions viewWillAppear");
    [super viewWillAppear:animated];

    self.directions = @[];

    NSDictionary *gdOptions = @{@"sensor": @"true",
                                @"key": [[AppSettings settings] valueForKey:@"GoogleDirectionsAPIKey"],
                                @"origin": self.sourceAddress,
                                @"destination": self.destinationAddress};
    GDDirectionsService *directionsService = [[GDDirectionsService alloc] init];
    [directionsService directionsQuery:gdOptions resultsBlock:^(NSDictionary *json, NSError *error) {
        if (error || (json && ![json[@"status"] isEqualToString:@"OK"])) {
            // Handle error
            return;
        }
        self.json = json;
        NSArray * legs = json[@"routes"][0][@"legs"];
        if ([legs count] < 1) {
            // Handle error
            return;
        }
        self.directions = legs[0][@"steps"];
        [self.tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancel:(id)sender {
    [self.delegate directionsListViewControllerDidClose:self withDirectionsJson:self.json];
}

- (IBAction)action:(id)sender {
    [self openDirectionsActionSheet];
}

#pragma mark - TableView delegate

#pragma mark - TableView datasource

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"DirectionsCell";

    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier
                                                                 forIndexPath:indexPath];
    NSDictionary *directionsStep = (NSDictionary*)self.directions[indexPath.row];
    [cell.textLabel setHtmlText:directionsStep[@"html_instructions"]
                 withAttributes:@{NSForegroundColorAttributeName: [VIPColor primaryTextColor]}];
    cell.detailTextLabel.text = directionsStep[@"distance"][@"text"];
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

- (NSURL*)makeMapsURL:(NSString*)sourceUrl
{
    NSString *urlString = [NSString stringWithFormat:sourceUrl, self.sourceAddress, self.destinationAddress];
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    return url;

}

- (NSURL*)makeAppleMapsURL
{
    static NSString *appleMapsUrl = @"http://maps.apple.com/?saddr=%@&daddr=%@";
    return [self makeMapsURL:appleMapsUrl];
}

- (NSURL*)makeGoogleMapsURL
{
    static NSString *googleMapsUrl = @"comgooglemaps://?saddr=%@&daddr=%@&directionsmode=driving";
    return [self makeMapsURL:googleMapsUrl];
}

@end
