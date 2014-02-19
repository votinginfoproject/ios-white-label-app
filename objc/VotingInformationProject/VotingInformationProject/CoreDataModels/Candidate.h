//
//  Candidate.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/17/14.
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
@property (nonatomic, retain) NSSet *socialChannels;
@end

@interface Candidate (CoreDataGeneratedAccessors)

- (void)addSocialChannelsObject:(NSManagedObject *)value;
- (void)removeSocialChannelsObject:(NSManagedObject *)value;
- (void)addSocialChannels:(NSSet *)values;
- (void)removeSocialChannels:(NSSet *)values;

@end
