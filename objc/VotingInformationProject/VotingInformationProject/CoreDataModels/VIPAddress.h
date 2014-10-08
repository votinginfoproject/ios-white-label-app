//
//  VIPAddress.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 6/23/14.
//

#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>

#import "JSONModel.h"

#define VA_MIN_LAT -999
#define VA_MIN_LON -999

@protocol VIPAddress
@end

@interface VIPAddress : JSONModel

@property (nonatomic, strong) NSString<Optional> * locationName;
@property (nonatomic, strong) NSString<Optional> * city;
@property (nonatomic, strong) NSString<Optional> * line1;
@property (nonatomic, strong) NSString<Optional> * line2;
@property (nonatomic, strong) NSString<Optional> * line3;
@property (nonatomic, strong) NSString<Optional> * state;
@property (nonatomic, strong) NSString<Optional> * zip;
@property (nonatomic, strong) NSNumber<Optional>* latitude;
@property (nonatomic, strong) NSNumber<Optional>* longitude;
@property (readonly) CLLocationCoordinate2D position;

@end
