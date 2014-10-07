//
//  PollingLocation.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 6/23/14.
//

#import <Foundation/Foundation.h>
#import "VIPModel.h"

#import "DataSource.h"
#import "VIPAddress.h"

@protocol PollingLocation
@end

@interface PollingLocation : VIPModel

@property (nonatomic, strong) NSString<Optional> * name;
@property (nonatomic, strong) NSString<Optional> * notes;
@property (nonatomic, strong) NSString<Optional> * pollingHours;
@property (nonatomic, strong) NSDate<Optional> * startDate;
@property (nonatomic, strong) NSDate<Optional> * endDate;
@property (nonatomic, strong) NSString<Optional> * voterServices;
@property (nonatomic, strong) VIPAddress<Optional> *address;
@property (nonatomic, strong) NSArray<DataSource, Optional> *sources;

@end
