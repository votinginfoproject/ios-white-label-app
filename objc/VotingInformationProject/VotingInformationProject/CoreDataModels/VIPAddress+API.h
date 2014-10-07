//
//  VIPAddress+API.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/5/14.
//  
//

#import "VIPAddress.h"

#import <CoreLocation/CoreLocation.h>

#import "VIPError.h"

@interface VIPAddress (API)

- (NSString*)toABAddressString:(BOOL)withNewlines;

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
