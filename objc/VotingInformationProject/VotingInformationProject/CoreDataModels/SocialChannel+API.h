//
//  SocialChannel+API.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/18/14.
//

#import "SocialChannel.h"

@interface SocialChannel (API)

/**
 * Return the id field as an NSURL
 *
 *  According to the VIP folks, the id field will always be a url,
 *      so we can just pass it to [NSURL URLWithString]
 *
 * @return NSURL for id or nil if no id field
 */
- (NSURL*)url;

/**
 Get the proper social media logo as UIImage based on type
 *
 * @return UIImage* The image, or nil if no type matches
 */
- (UIImage*)logo;

@end
