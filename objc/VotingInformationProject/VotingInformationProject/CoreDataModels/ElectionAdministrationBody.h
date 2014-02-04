//
//  ElectionAdministrationBody.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/4/14.
//  Copyright (c) 2014 Bennet Huber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ElectionOfficial, State, VIPAddress;

@interface ElectionAdministrationBody : NSManagedObject

@property (nonatomic, retain) NSString * absenteeVotingInfoURL;
@property (nonatomic, retain) NSString * ballotInfoURL;
@property (nonatomic, retain) NSString * electionInfoURL;
@property (nonatomic, retain) NSString * electionRegistrationConfirmationURL;
@property (nonatomic, retain) NSString * electionRegistrationURL;
@property (nonatomic, retain) NSString * electionRulesURL;
@property (nonatomic, retain) NSString * hoursOfOperation;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * voterServices;
@property (nonatomic, retain) NSString * votingLocationFinderURL;
@property (nonatomic, retain) NSSet *addresses;
@property (nonatomic, retain) NSSet *electionOfficials;
@property (nonatomic, retain) State *state;
@end

@interface ElectionAdministrationBody (CoreDataGeneratedAccessors)

- (void)addAddressesObject:(VIPAddress *)value;
- (void)removeAddressesObject:(VIPAddress *)value;
- (void)addAddresses:(NSSet *)values;
- (void)removeAddresses:(NSSet *)values;

- (void)addElectionOfficialsObject:(ElectionOfficial *)value;
- (void)removeElectionOfficialsObject:(ElectionOfficial *)value;
- (void)addElectionOfficials:(NSSet *)values;
- (void)removeElectionOfficials:(NSSet *)values;

@end
