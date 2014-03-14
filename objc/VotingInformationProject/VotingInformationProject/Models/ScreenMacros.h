//
//  ScreenMacros.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 3/14/14.
//

#ifndef VotingInformationProject_ScreenMacros_h
#define VotingInformationProject_ScreenMacros_h

#define IS_WIDESCREEN (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)568) < DBL_EPSILON)
#define IS_IPHONE ([[[UIDevice currentDevice] model] isEqualToString:@"iPhone"])
#define IS_IPOD   ([[[UIDevice currentDevice] model] isEqualToString:@"iPod touch"])

#endif
