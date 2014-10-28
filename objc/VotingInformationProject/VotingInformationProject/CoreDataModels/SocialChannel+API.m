//
//  SocialChannel+API.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/18/14.
//

#import "SocialChannel+API.h"

@implementation SocialChannel (API)

- (NSURL*)url
{
    NSURL *url = nil;
    if (self.id) {
        url = [NSURL URLWithString:self.id];
    }
    return url;
}

- (UIImage*)logo
{
    UIImage *image = nil;
    NSString *lowerCaseType = [self.type lowercaseString];
    if ([lowerCaseType isEqualToString:@"facebook"]) {
        image = [UIImage imageNamed:@"Candidate_facebook"];
    } else if ([lowerCaseType isEqualToString:@"twitter"]) {
        image = [UIImage imageNamed:@"Candidate_twitter"];
    } else if ([lowerCaseType isEqualToString:@"googleplus"]) {
        image = [UIImage imageNamed:@"Candidate_google"];
    } else if ([lowerCaseType isEqualToString:@"youtube"]) {
        image = [UIImage imageNamed:@"Candidate_youtube"];
    }
    return image;
}

@end
