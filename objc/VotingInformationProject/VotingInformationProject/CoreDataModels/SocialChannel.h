//
//  SocialChannel.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/17/14.
//  Copyright (c) 2014 Bennet Huber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Candidate;

@interface SocialChannel : VIPManagedObject

@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) Candidate *candidate;

@end
