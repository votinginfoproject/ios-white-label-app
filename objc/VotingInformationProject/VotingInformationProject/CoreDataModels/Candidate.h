//
//  Candidate.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 6/23/14.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Contest, SocialChannel;

@interface Candidate : VIPManagedObject

@property (nonatomic, retain) NSString * candidateUrl;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * orderOnBallot;
@property (nonatomic, retain) NSString * party;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSData * photo;
@property (nonatomic, retain) NSString * photoUrl;
@property (nonatomic, retain) Contest *contest;
@property (nonatomic, retain) NSSet *socialChannels;
@end

@interface Candidate (CoreDataGeneratedAccessors)

- (void)addSocialChannelsObject:(SocialChannel *)value;
- (void)removeSocialChannelsObject:(SocialChannel *)value;
- (void)addSocialChannels:(NSSet *)values;
- (void)removeSocialChannels:(NSSet *)values;

@end
