//
//  VIPAddress.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 6/23/14.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "VIPManagedAddress.h"

@class ElectionAdministrationBody, PollingLocation;

@interface VIPAddress : VIPManagedAddress

@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * line1;
@property (nonatomic, retain) NSString * line2;
@property (nonatomic, retain) NSString * line3;
@property (nonatomic, retain) NSString * locationName;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSString * zip;
@property (nonatomic, retain) ElectionAdministrationBody *eab;
@property (nonatomic, retain) PollingLocation *pollingLocation;

@end
