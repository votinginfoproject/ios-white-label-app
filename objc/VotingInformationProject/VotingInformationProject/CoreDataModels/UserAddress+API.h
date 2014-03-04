//
//  UserAddress+API.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/3/14.
//  
//

#import "UserAddress.h"

#import <CoreLocation/CoreLocation.h>

#define UA_MIN_LAT -999
#define UA_MIN_LON -999

@interface UserAddress (API)

// UNIQUE: UserAddress.address
+ (UserAddress*)getUnique:(NSString *)address;

/**
 *  Geocode the address and store in latitude/longitude properties
 *
 *  @param resultsBlock Block to execute when the request finishes. error != nil if any type of 
 *                      failure of the request occurs. If the request fails, the position arg will have
 *                      its values set to UA_MIN_LAT/UA_MIN_LON
 *
 */
- (void)geocode:(void (^)(CLLocationCoordinate2D position, NSError *error))resultsBlock;

- (BOOL) hasAddress;

@end
