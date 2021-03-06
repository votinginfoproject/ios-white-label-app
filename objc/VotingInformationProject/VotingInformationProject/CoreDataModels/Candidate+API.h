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
 *  Helper method to determine if a link of a particular type can be opened
 *
 *  @param link string url to open in the application
 *  @param type One of CandidateLinkTypes
 *
 *  @return YES if the system can open the specified link as type otherwise NO
 */
+ (BOOL)canOpenLink:(NSString*)link asType:(int)type;

/**
 *  Helper method to make an NSURL of type kCandidateLinkTypeEmail
 *
 *  @param email email address to make url from
 *
 *  @return NSURL to be opened by system
 */
+ (NSURL*)makeEmailURL:(NSString*)email;

/**
 *  Helper method to make an NSURL of type kCandidateLinkTypePhone
 *
 *  @param phone phone number to make url from
 *
 *  @return NSURL to be opened by system
 */
+ (NSURL*)makePhoneURL:(NSString*)phone;

/**
 *  Helper method to make an NSURL of type kCandidateLinkTypeWebsite
 *
 *  @param website web link to make url from
 *
 *  @return NSURL to be opened by system
 */
+ (NSURL*)makeWebsiteURL:(NSString*)website;

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
