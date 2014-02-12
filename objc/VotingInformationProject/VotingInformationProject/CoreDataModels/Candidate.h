//
//  Candidate.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/6/14.
//  
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Contest;

@interface Candidate : VIPManagedObject

@property (nonatomic, retain) NSString * candidateUrl;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * orderOnBallot;
@property (nonatomic, retain) NSString * party;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSData * photo;
@property (nonatomic, retain) NSString * photoUrl;
@property (nonatomic, retain) Contest *contest;

@end
