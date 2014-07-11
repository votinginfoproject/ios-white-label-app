//
//  ElectionAdministrationBody+API.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/5/14.
//  
//

#import "ElectionAdministrationBody.h"
#import "ElectionOfficial+API.h"
#import "VIPAddress+API.h"

@interface ElectionAdministrationBody (API)

+ (ElectionAdministrationBody*) setFromDictionary:(NSDictionary*)attributes;

- (NSMutableArray *)getProperties;
@end
