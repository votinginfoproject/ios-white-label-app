//
//  GDDirectionsService.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 4/1/14.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef enum {
    kGDDirectionsTypeDriving = 0,
    kGDDirectionsTypeTransit = 1,
    kGDDirectionsTypeCycling = 2,
    kGDDirectionsTypeWalking = 3
} kGDDirectionsType;

/*
 * Helper class for making requests to the Google Directions API
 * Only supports HTTPS
 */
@interface GDDirectionsService : NSObject

/**
 *  Query the Google Directions API
 *
 *  @param options      NSDictionary of options where the keys match the options outlined here:
 *                      https://developers.google.com/maps/documentation/directions/#RequestParameters
 *  @param resultsBlock The block to call when the request completes.
 */
- (void) directionsQuery:(NSDictionary*)options
            resultsBlock:(void (^)(NSDictionary *json, NSError *error))resultsBlock;

- (NSString*)directionsTypeToString:(kGDDirectionsType)type;

@end
