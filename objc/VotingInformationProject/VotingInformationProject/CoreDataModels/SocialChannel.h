//
//  SocialChannel.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 6/23/14.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Candidate;

@interface SocialChannel : VIPManagedObject

@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) Candidate *candidate;

@end
