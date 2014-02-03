//
//  Candidate.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 1/31/14.
//  Copyright (c) 2014 Bennet Huber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Contest;

@interface Candidate : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * party;
@property (nonatomic, retain) NSString * candidateURL;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * photoURL;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSNumber * orderOnBallot;
@property (nonatomic, retain) NSData * photo;
@property (nonatomic, retain) Contest *contest;

@end
