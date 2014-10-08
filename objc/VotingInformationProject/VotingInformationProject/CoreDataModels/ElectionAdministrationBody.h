//
//  ElectionAdministrationBody.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 6/23/14.
//

#import <Foundation/Foundation.h>
#import "VIPModel.h"

#import "DataSource.h"
#import "ElectionOfficial.h"
#import "VIPAddress.h"

@protocol ElectionAdministrationBody
@end

@interface ElectionAdministrationBody : VIPModel

@property (nonatomic, strong) NSString<Optional> * name;
@property (nonatomic, strong) NSString<Optional> * electionInfoUrl;
@property (nonatomic, strong) NSString<Optional> * electionRegistrationUrl;
@property (nonatomic, strong) NSString<Optional> * electionRegistrationConfirmationUrl;
@property (nonatomic, strong) NSString<Optional> * absenteeVotingInfoUrl;
@property (nonatomic, strong) NSString<Optional> * votingLocationFinderUrl;
@property (nonatomic, strong) NSString<Optional> * ballotInfoUrl;
@property (nonatomic, strong) NSString<Optional> * electionRulesUrl;
@property (nonatomic, strong) NSString<Optional> * hoursOfOperation;
@property (nonatomic, strong) NSArray<Ignore> * voterServices;
@property (nonatomic, strong) VIPAddress<Optional> *correspondenceAddress;
@property (nonatomic, strong) VIPAddress<Optional> *physicalAddress;
@property (nonatomic, strong) ElectionAdministrationBody<Optional> * local_jurisdiction;
@property (nonatomic, strong) NSArray<ElectionOfficial, Optional> *electionOfficials;
@property (nonatomic, strong) NSArray<DataSource, Optional> *sources;

@end
