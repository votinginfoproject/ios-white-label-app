//
//  ElectionOfficial.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 1/31/14.
//  Copyright (c) 2014 Bennet Huber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ElectionAdministrationBody;

@interface ElectionOfficial : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * officePhoneNumber;
@property (nonatomic, retain) NSString * faxNumber;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) ElectionAdministrationBody *electionAdministrationBody;

@end
