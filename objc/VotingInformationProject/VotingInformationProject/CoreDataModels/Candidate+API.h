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

typedef enum {
    kCandidateLinkTypeWebsite,
    kCandidateLinkTypeEmail,
    kCandidateLinkTypePhone,
    kCandidateLinkTypeUnknown
} CandidateLinkTypes;

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

/**
 *  An array of objects, where each object relates to a single property of Candidate.
 *  The dictionary has the following keys:
 *      description: Translated, NSString property description for use in UI
 *      buttonTitle: Translated, NSString button title for use in UI
 *      url: The url to load when the button is clicked on.
 *      urlScheme: One of CandidateLinkTypes used to determine the url scheme
 *
 *  @return NSMutableArray of object properties
 */
- (NSMutableArray*)getLinksDataArray;

@end
