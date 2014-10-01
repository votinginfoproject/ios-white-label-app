//
//  DirectionsViewSegueData.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 10/1/14.
//

#import <Foundation/Foundation.h>

@interface DirectionsViewSegueData : NSObject

@property (strong, nonatomic) NSString* destination;
@property (strong, nonatomic) NSString* source;

+ (DirectionsViewSegueData*) dataWithSource:(NSString*)source andDestination:(NSString*)destination;

@end
