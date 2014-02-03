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
#import "UserAddress+API.h"

@interface NearbyPollingViewController : UIViewController

-(void) setPlacemark:(UserAddress *)userAddress
          andAnimate:(BOOL)animate;

- (void) geocode:(UserAddress *)userAddress
 andSetPlacemark:(BOOL)setPlacemark;

@end
