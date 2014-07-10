//
//  PollingInfoWindowView.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 7/10/14.
//

#import <UIKit/UIKit.h>
#import "PollingLocationWrapper.h"

@interface PollingInfoWindowView : UIView

/**
 *  Create a new PollingInfoWindow sized to fit data in PollingLocationWrapper
 *  DESIGNATED INITIALIZER
 *
 *  @param plWrapper
 *
 *  @return new PollingInfoWindowView
 */
- (instancetype)initWithFrame:(CGRect)frame
    andPollingLocationWrapper:(PollingLocationWrapper*)plWrapper;

@end
