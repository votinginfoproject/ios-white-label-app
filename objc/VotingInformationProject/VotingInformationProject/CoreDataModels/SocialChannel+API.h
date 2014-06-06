//
//  SocialChannel+API.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/18/14.
//

#import "SocialChannel.h"

@interface SocialChannel (API)

/**
 * Return the unique NSURL constructed from the social channel id/type
 *
 * @return NSURL The url, e.g. "https://twitter.com/votinginfo for id: votinginfo, type: Twitter
 */
- (NSURL*)url;

/**
 Get the proper social media logo as UIImage based on type
 *
 * @return UIImage* The image, or nil if no type matches
 */
- (UIImage*)logo;

@end
