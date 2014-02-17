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
    NSURLSessionDataTask *getPhotoDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

        if (error) {
            NSLog(@"Candidate %@ error getting photo: %@", self.name, error);
            return;
        }
        self.photo = data;
    }];

    // Execute request
    [getPhotoDataTask resume];
}

+ (Candidate*) setFromDictionary:(NSDictionary *)attributes
{
    NSMutableDictionary *mutableAttributes = [attributes mutableCopy];

    // TODO: Remove this section if we want to store channels later 
    NSString *channelsKey = @"channels";
    [mutableAttributes removeObjectForKey:channelsKey];

    Candidate *candidate = [Candidate MR_createEntity];
    // Set attributes
    [candidate setValuesForKeysWithDictionary:mutableAttributes];

    // Download photo from url
    [candidate getCandidatePhotoData];

    return candidate;
}
@end
