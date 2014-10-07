//
//  Candidate.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 6/23/14.
//

#import "VIPModel.h"

#import "SocialChannel.h"

@protocol Candidate
@end

@interface Candidate : VIPModel 

@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString<Optional>* party;
@property (nonatomic, strong) NSString<Optional>* candidateUrl;
@property (nonatomic, strong) NSString<Optional>* phone;
@property (nonatomic, strong) NSString<Optional>* photoUrl;
@property (nonatomic, strong) NSString<Optional>* email;
@property (nonatomic, assign) long orderOnBallot;
@property (nonatomic, strong) NSArray<SocialChannel, Optional>* channels;
@property (nonatomic, strong) NSData<Ignore>* photo;

@end
