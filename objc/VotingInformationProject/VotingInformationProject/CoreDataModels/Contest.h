//
//  Contest.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 10/6/14.
//

#import "VIPModel.h"

#import "Candidate.h"
#import "DataSource.h"
#import "District.h"

@protocol Contest
@end

@interface Contest : VIPModel

@property (nonatomic, strong) NSString<Optional> * type;
@property (nonatomic, strong) NSString<Optional> * primaryParty;
@property (nonatomic, strong) NSString<Optional> * electorateSpecifications;
@property (nonatomic, strong) NSString<Optional> * special;
@property (nonatomic, strong) NSString<Optional> * office;
@property (nonatomic, strong) NSArray<Ignore>* level;
@property (nonatomic, strong) NSArray<Ignore>* roles;
@property (nonatomic, strong) District<Optional> *district;
@property (nonatomic, strong) NSNumber<Optional> * numberElected;
@property (nonatomic, strong) NSNumber<Optional> * numberVotingFor;
@property (nonatomic, strong) NSNumber<Optional> * ballotPlacement;
@property (nonatomic, strong) NSArray<Candidate, Optional> *candidates;
@property (nonatomic, strong) NSString<Optional> * referendumTitle;
@property (nonatomic, strong) NSString<Optional> * referendumBrief;
@property (nonatomic, strong) NSString<Optional> * referendumSubtitle;
@property (nonatomic, strong) NSString<Optional> * referendumText;
@property (nonatomic, strong) NSString<Optional> * referendumProStatement;
@property (nonatomic, strong) NSString<Optional> * referendumConStatement;
@property (nonatomic, strong) NSString<Optional> * referendumUrl;
@property (nonatomic, strong) NSString<Optional> * referendumPassageThreshold;
@property (nonatomic, strong) NSArray<DataSource, Optional>* sources;

@end
