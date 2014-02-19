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
- (NSURL*) uniqueUrl;

@end
