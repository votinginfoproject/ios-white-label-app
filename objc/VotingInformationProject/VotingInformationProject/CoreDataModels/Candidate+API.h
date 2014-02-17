//
//  Candidate+API.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/6/14.
//  
//

#import "Candidate.h"
#import "SocialChannel.h"

@interface Candidate (API)

/**
 Create and return an instance of Candidate from a dictionary

 @param attributes NSDictionary of the attributes to set

 @see VIPManagedObject setFromDictionary:
 */
+ (Candidate*) setFromDictionary:(NSDictionary*)attributes;

/**
 *  Set photo property from the photoUrl property if it exists
 *  Value of photo is untouched if any errors occur
 */
- (void)getCandidatePhotoData;

- (NSMutableArray*)getLinksDataArray;

@end
