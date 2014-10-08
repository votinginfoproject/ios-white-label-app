//
//  VIPAddress.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 6/23/14.
//

#import "VIPAddress.h"


@implementation VIPAddress

- (CLLocationCoordinate2D)position
{
    return CLLocationCoordinate2DMake(self.latitude.doubleValue, self.longitude.doubleValue);
}

@end
