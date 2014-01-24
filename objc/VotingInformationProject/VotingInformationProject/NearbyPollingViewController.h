//
//  NearbyPollingViewController.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 1/22/14.
//  Copyright (c) 2014 Bennet Huber. All rights reserved.
//

#import "VIPUserDefaultsKeys.h"
#import <UIKit/UIKit.h>
#import "GoogleMaps/GoogleMaps.h"

@interface NearbyPollingViewController : UIViewController

-(void) setPlacemark:(CLPlacemark *)placemark
          andAnimate:(BOOL)animate;

- (void) geocode:(NSString *)address;

@end
