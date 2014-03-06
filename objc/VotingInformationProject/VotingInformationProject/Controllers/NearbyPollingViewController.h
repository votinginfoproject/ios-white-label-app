//
//  NearbyPollingViewController.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 1/22/14.
//  
//

#import <UIKit/UIKit.h>

#import "GoogleMaps/GoogleMaps.h"

#import "VIPUserDefaultsKeys.h"
#import "Election+API.h"

@interface NearbyPollingViewController : UIViewController <GMSMapViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) Election *election;
@property (strong, nonatomic) NSArray *locations;

-(GMSMarker*) setPlacemark:(CLPlacemark*)userAddress
                 withTitle:(NSString*)title
                andAnimate:(BOOL)animate;

- (void) geocode:(UserAddress *)userAddress
 andSetPlacemark:(BOOL)setPlacemark;

- (IBAction)onViewSwitcherClicked:(id)sender;

@end
