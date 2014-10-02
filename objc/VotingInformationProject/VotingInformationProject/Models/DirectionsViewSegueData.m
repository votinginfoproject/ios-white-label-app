//
//  DirectionsViewSegueData.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 10/1/14.
//

#import "DirectionsViewSegueData.h"

@implementation DirectionsViewSegueData

+ (DirectionsViewSegueData*)dataWithSource:(NSString *)source andDestination:(NSString *)destination
{
    DirectionsViewSegueData *data = [[DirectionsViewSegueData alloc] init];
    data.destination = destination;
    data.source = source;
    return data;
}

@end
