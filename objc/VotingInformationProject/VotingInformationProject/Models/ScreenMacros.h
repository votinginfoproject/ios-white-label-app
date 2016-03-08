//
//  ScreenMacros.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 3/14/14.
//

#ifndef VotingInformationProject_ScreenMacros_h
#define VotingInformationProject_ScreenMacros_h

#import <UIKit/UIDevice.h>
#import <UIKit/UIScreen.h>

#define WIDESCREEN_HEIGHT 568
// Quickfix because using the < DBL_EPSILON solution was failing the travis ci with DBL_EPSILON
//  not found for some reason.
#define IS_WIDESCREEN (abs((double)[[UIScreen mainScreen] bounds].size.height > (double)WIDESCREEN_HEIGHT - 1))
#define IS_IPHONE ([[[UIDevice currentDevice] model] isEqualToString:@"iPhone"])
#define IS_IPOD   ([[[UIDevice currentDevice] model] isEqualToString:@"iPod touch"])

#endif
