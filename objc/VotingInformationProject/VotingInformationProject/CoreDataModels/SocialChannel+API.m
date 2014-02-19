//
//  SocialChannel+API.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/18/14.
//

#import "SocialChannel+API.h"

@implementation SocialChannel (API)

- (NSURL*)uniqueUrl
{
    NSURL *url = nil;
    NSString *urlTemplate = [self getUrlTemplate];
    if (self.id && urlTemplate) {
        NSString *urlString = [NSString stringWithFormat:urlTemplate, self.id];
        url = [NSURL URLWithString:urlString];
    }
    return url;
}

/**
 *  Gets the url template string that the social media id can be pasted into
 *
 *  @return NSString url template, e.g. @"https://twitter.com/%@" for type == twitter
 */
- (NSString*) getUrlTemplate
{
    NSString *urlTemplate = nil;
    NSString *lowerCaseType = [self.type lowercaseString];
    if (lowerCaseType) {
        if ([lowerCaseType isEqualToString:@"twitter"]) {
            urlTemplate = [NSString stringWithFormat:@"https://twitter.com/%%@"];
        } else if ([lowerCaseType isEqualToString:@"facebook"]) {
            urlTemplate = [NSString stringWithFormat:@"https://facebook.com/%%@"];
        } else if ([lowerCaseType isEqualToString:@"googleplus"]) {
            urlTemplate = [NSString stringWithFormat:@"https://plus.google.com/%%@"];
        } else if ([lowerCaseType isEqualToString:@"youtube"]) {
            urlTemplate = [NSString stringWithFormat:@"https://www.youtube.com/user/%%@"];
        }
    }
    return urlTemplate;
}

@end
