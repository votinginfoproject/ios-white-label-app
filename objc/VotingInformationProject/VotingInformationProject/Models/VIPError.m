//
//  VIPError.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 3/4/14.
//

#import "VIPError.h"

@implementation VIPError

// Error domain for this class for use in NSError
NSString * const VIPErrorDomain = @"com.votinginfoproject.whitelabel.error";

// Error codes used by this class and elsewhere in NSError
NSUInteger const VIPNoValidElections = 100;
NSUInteger const VIPInvalidUserAddress = 101;
NSUInteger const VIPAddressUnparseable = 102;
NSUInteger const VIPNoAddress = 103;
NSUInteger const VIPElectionUnknown = 104;
NSUInteger const VIPElectionOver = 105;
NSUInteger const VIPGenericAPIError = 200;

NSUInteger const VIPGeocoderError = 300;

// String descriptions of the above error codes
// Get value with localizedDescriptionForErrorCode:
static NSString * VIPAddressUnparseableDescription;
static NSString * VIPNoAddressDescription;
static NSString * VIPGenericAPIErrorDescription;
static NSString * VIPElectionOverDescription;
static NSString * VIPElectionUnknownDescription;
static NSString * VIPInvalidUserAddressDescription;
static NSString * VIPNoValidElectionsDescription;
static NSString * VIPGeocoderErrorDescription;

// Definitions for the various possible responses from the voterInfo API
// Not translated because these are used internally and are explicit maps to the
//  voterInfo query v1 response
NSString * const APIResponseSuccess = @"success";
NSString * const APIResponseElectionOver = @"electionOver";
NSString * const APIResponseElectionUnknown = @"electionUnknown";
NSString * const APIResponseNoStreetSegmentFound = @"noStreetSegmentFound";
NSString * const APIResponseMultipleStreetSegmentsFound = @"multipleStreetSegmentsFound";
NSString * const APIResponseNoAddressParameter = @"noAddressParameter";

+ (void) initialize
{
    [super initialize];

    // We define strings this way, rather than via extern NSString* const because localized strings
    // defined like so:
    //  NSString * const foo = @"foo";
    //  NSString *localizedFoo = NSLocalizedString(foo, nil);
    // is not picked up by the genstrings tool.
    VIPAddressUnparseableDescription = NSLocalizedString(@"Address unparseable. Please reformat your address or provide more detail such as street name.", nil);
    VIPNoAddressDescription = NSLocalizedString(@"No address provided", nil);
    VIPGenericAPIErrorDescription = NSLocalizedString(@"An unknown API error has occurred. Please try again later.", nil);
    VIPElectionOverDescription = NSLocalizedString(@"This election is over.", nil);
    VIPElectionUnknownDescription = NSLocalizedString(@"Unknown election. Please try again later.", nil);
    VIPInvalidUserAddressDescription = NSLocalizedString(@"Weird. It looks like we can't find your address. Maybe double check that it's right and try again.", nil);
    VIPNoValidElectionsDescription = NSLocalizedString(@"Sorry, there is no information for an upcoming election near you. Information about elections is generally available two to four weeks before the election date.", nil);
    VIPGeocoderErrorDescription = NSLocalizedString(@"Sorry, there are no location matches for this address. Try reformatting it or type a new one.", nil);
}

+ (NSString *)localizedDescriptionForAPIErrorCode:(NSUInteger)errorCode
{
    switch (errorCode) {
        case VIPAddressUnparseable:
            return VIPAddressUnparseableDescription;

        case VIPNoAddress:
            return VIPNoAddressDescription;

        case VIPElectionOver:
            return VIPElectionOverDescription;

        case VIPElectionUnknown:
            return VIPElectionUnknownDescription;

        case VIPInvalidUserAddress:
            return VIPInvalidUserAddressDescription;

        case VIPNoValidElections:
            return VIPNoValidElectionsDescription;

        case VIPGeocoderError:
            return VIPGeocoderErrorDescription;

        default:
            return VIPGenericAPIErrorDescription;
    }
}

+ (NSError*)errorWithCode:(NSUInteger)errorCode
{
    NSString *errorString = [VIPError localizedDescriptionForAPIErrorCode:errorCode];
    NSError *error = [NSError errorWithDomain:VIPErrorDomain
                                         code:errorCode
                                     userInfo:@{NSLocalizedDescriptionKey: errorString}];
    return error;
}

@end
