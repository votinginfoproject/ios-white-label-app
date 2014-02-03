//
//  ElectionAdministrationBody.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 1/31/14.
//  Copyright (c) 2014 Bennet Huber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ElectionOfficial, State;

@interface ElectionAdministrationBody : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * electionInfoURL;
@property (nonatomic, retain) NSString * electionRegistrationURL;
@property (nonatomic, retain) NSString * electionRegistrationConfirmationURL;
@property (nonatomic, retain) NSString * absenteeVotingInfoURL;
@property (nonatomic, retain) NSString * votingLocationFinderURL;
@property (nonatomic, retain) NSString * ballotInfoURL;
@property (nonatomic, retain) NSString * electionRulesURL;
@property (nonatomic, retain) NSString * voterServices;
@property (nonatomic, retain) NSString * hoursOfOperation;
@property (nonatomic, retain) NSString * physicalAddress;
@property (nonatomic, retain) NSString * mailingAddress;
@property (nonatomic, retain) State *state;
@property (nonatomic, retain) NSSet *electionOfficials;
@end

@interface ElectionAdministrationBody (CoreDataGeneratedAccessors)

- (void)addElectionOfficialsObject:(ElectionOfficial *)value;
- (void)removeElectionOfficialsObject:(ElectionOfficial *)value;
- (void)addElectionOfficials:(NSSet *)values;
- (void)removeElectionOfficials:(NSSet *)values;

@end
