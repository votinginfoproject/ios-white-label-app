//
//  ElectionAdministrationBody+API.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/5/14.
//  Copyright (c) 2014 Bennet Huber. All rights reserved.
//

#import "ElectionAdministrationBody.h"
#import "ElectionOfficial.h"
#import "VIPAddress+API.h"

@interface ElectionAdministrationBody (API)

+ (ElectionAdministrationBody*) setFromDictionary:(NSDictionary*)attributes
                                    withAddresses:(NSArray*)addresses
                            withElectionOfficials:(NSArray*)officials;


@end
