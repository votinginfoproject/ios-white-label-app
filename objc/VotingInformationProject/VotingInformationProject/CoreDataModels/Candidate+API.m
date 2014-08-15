//
//  Candidate+API.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/6/14.
//  
//

#import "Candidate+API.h"

@implementation Candidate (API)

- (void)getCandidatePhotoData
{
    if (!self.photoUrl) {
        return;
    }

    NSURLSessionConfiguration* sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:sessionConfig];
    NSURL *url = [NSURL URLWithString:self.photoUrl];

    // Create URL request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"GET";

    // Create data task
    NSURLSessionDataTask *getPhotoDataTask =
    [session dataTaskWithRequest:request
               completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
    {
        if (error) {
            NSLog(@"Candidate %@ error getting photo: %@", self.name, error);
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            @try {
                self.photo = data;
            } @catch (NSException *e) {
                NSLog(@"Unable to save candidate photo data: %@", e.name);
            }
        });
    }];

    // Execute request
    [getPhotoDataTask resume];
}

- (NSMutableArray*)getLinksDataArray
{
    NSMutableArray *links = [[NSMutableArray alloc] initWithCapacity:3];
    if (self.candidateUrl) {
        [links addObject:@{
                           @"buttonTitle": NSLocalizedString(@"Website", @"Button name for candidate's website"),
                           @"description": NSLocalizedString(@"Website", @"Link description for candidate's website"),
                           @"url": self.candidateUrl,
                           @"urlScheme": @(kCandidateLinkTypeWebsite)
                           }];
    }
    if (self.phone) {
        [links addObject:@{
                           @"buttonTitle": NSLocalizedString(@"Call", @"Button name for candidate's phone number"),
                           @"description": NSLocalizedString(@"Phone", @"Link description for candidate's phone number"),
                           @"url": self.phone,
                           @"urlScheme": @(kCandidateLinkTypePhone)
                           }];
    }
    if (self.email) {
        [links addObject:@{
                           @"buttonTitle": NSLocalizedString(@"Email", @"Button name for candidate's email address"),
                           @"description": NSLocalizedString(@"Email", @"Link description for candidate's email address"),
                           @"url": self.email,
                           @"urlScheme": @(kCandidateLinkTypeEmail)
                           }];
    }
    return links;
}

+ (Candidate*) setFromDictionary:(NSDictionary *)attributes
{
    NSMutableDictionary *mutableAttributes = [attributes mutableCopy];

    NSString *channelsKey = @"channels";
    NSArray* channels = attributes[channelsKey];
    [mutableAttributes removeObjectForKey:channelsKey];

    Candidate *candidate = [Candidate MR_createEntity];
    // Set attributes
    [candidate updateFromDictionary:mutableAttributes];

    // Set Social Channels
    for (NSDictionary* channel in channels) {
        SocialChannel *sc = (SocialChannel*)[SocialChannel setFromDictionary:channel];
        [candidate addSocialChannelsObject:sc];
    }

    // Download photo from url
    [candidate getCandidatePhotoData];

    return candidate;
}

/**
 *  Temporary method for stubbing a bit of candidate data for testing
 *  Sets social channels and an email/phone
 *  @warning Remove for final release
 */
- (void) stubCandidateData
{
#if DEBUG
        SocialChannel *twitter =
        (SocialChannel*)[SocialChannel setFromDictionary:@{@"type": @"Twitter", @"id": @"VotingInfo"}];
        [self addSocialChannelsObject:twitter];

        SocialChannel *facebook =
        (SocialChannel*)[SocialChannel setFromDictionary:@{@"type": @"Facebook", @"id": @"VotingInfo"}];
        [self addSocialChannelsObject:facebook];

        SocialChannel *youtube =
        (SocialChannel*)[SocialChannel setFromDictionary:@{@"type": @"YouTube", @"id": @"pew"}];
        [self addSocialChannelsObject:youtube];

        self.email = @"info@azavea.com";
        self.phone = @"(123)456-7890";
#endif
}

@end
