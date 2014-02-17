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
        self.photo = data;
    }];

    // Execute request
    [getPhotoDataTask resume];
}

- (NSMutableArray*)getLinksDataArray
{
    NSArray *properties = @[@"candidateUrl", @"phone", @"email"];
    NSMutableArray *links = [[NSMutableArray alloc] initWithCapacity:[properties count]];
    for (NSString* property in properties) {
        NSString* value = [self valueForKey:property];
        if (value) {
            [links addObject:@{property: value}];
        }
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
    [candidate setValuesForKeysWithDictionary:mutableAttributes];

    // Set Social Channels
    for (NSDictionary* channel in channels) {
        [candidate addSocialChannelsObject:[SocialChannel setFromDictionary:channel]];
    }

    // Download photo from url
    [candidate getCandidatePhotoData];

    return candidate;
}
@end
