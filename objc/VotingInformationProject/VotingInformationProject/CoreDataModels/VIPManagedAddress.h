//
//  VIPManagedAddress.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 3/4/14.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <CoreLocation/CoreLocation.h>

#import "VIPError.h"

#define VA_MIN_LAT -999
#define VA_MIN_LON -999

@interface VIPManagedAddress : VIPManagedObject

@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * address;

/**
 *  Geocode the address and store in latitude/longitude properties
 *
 *  @param resultsBlock Block to execute when the request finishes. error != nil if any type of 
 *                      failure of the request occurs. If the request fails, the position arg will have
 *                      its values set to UA_MIN_LAT/UA_MIN_LON
 *
 */
- (void)geocode:(void (^)(CLLocationCoordinate2D position, NSError *error))resultsBlock;

@end
