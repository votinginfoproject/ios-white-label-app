//
//  GDDirectionsService.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 4/1/14.
//

#import "GDDirectionsService.h"

#import <AFNetworking/AFNetworking.h>

@implementation GDDirectionsService

static NSString * const GDDirectionsURL = @"https://maps.googleapis.com/maps/api/directions/json";

- (void)directionsQuery:(NSDictionary *)options
           resultsBlock:(void (^)(NSDictionary *, NSError *))resultsBlock
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:GDDirectionsURL
      parameters:options
         success:^(AFHTTPRequestOperation *operation, NSDictionary *json) {
             resultsBlock(json, nil);
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             resultsBlock(nil, error);
         }];
}

- (NSString*)directionsTypeToString:(kGDDirectionsType)type
{
    switch (type) {
        case kGDDirectionsTypeDriving:
            return @"driving";
        case kGDDirectionsTypeTransit:
            return @"transit";
        case kGDDirectionsTypeCycling:
            return @"bicycling";
        case kGDDirectionsTypeWalking:
            return @"walking";
        default:
            return @"driving";
    }
}

@end
