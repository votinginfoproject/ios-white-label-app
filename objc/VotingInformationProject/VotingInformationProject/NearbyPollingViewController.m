//
//  NearbyPollingViewController.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 1/22/14.
//  Copyright (c) 2014 Bennet Huber. All rights reserved.
//

#import "NearbyPollingViewController.h"
#import "GoogleMaps/GoogleMaps.h"

@interface NearbyPollingViewController ()
@property (strong, nonatomic) GMSMapView * mapView;
@end

@implementation NearbyPollingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Set map view and display
    double centerLat = 39.9522;
    double centerLon = -75.1639;
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:centerLat
                                                            longitude:centerLon
                                                                 zoom:13];
    self.mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    self.mapView.myLocationEnabled = YES;
    self.view = self.mapView;

    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(centerLat, centerLon);
    marker.title = @"City Hall, Philadelphia";
    marker.snippet = @"United States";
    marker.map = self.mapView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
