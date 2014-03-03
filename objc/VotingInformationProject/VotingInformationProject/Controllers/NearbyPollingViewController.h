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

@interface NearbyPollingViewController : UIViewController

@property (strong, nonatomic) Election *election;

-(void) setPlacemark:(UserAddress *)userAddress
          andAnimate:(BOOL)animate;

- (void) geocode:(UserAddress *)userAddress
 andSetPlacemark:(BOOL)setPlacemark;

@end
