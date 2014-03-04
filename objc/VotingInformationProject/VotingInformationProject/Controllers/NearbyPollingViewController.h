//
//  NearbyPollingViewController.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 1/22/14.
//  
//

#import <UIKit/UIKit.h>
#import "GoogleMaps/GoogleMaps.h"

#import "Election+API.h"
#import "VIPUserDefaultsKeys.h"

@interface NearbyPollingViewController : UIViewController <GMSMapViewDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) Election *election;
@property (strong, nonatomic) NSArray *locations;

@end
