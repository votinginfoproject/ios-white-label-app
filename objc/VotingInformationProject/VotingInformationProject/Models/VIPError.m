//
//  VIPError.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 3/4/14.
//

#import "VIPError.h"

@interface VIPErrorCode ()

@property (nonatomic) NSString *descriptionString;
@property (nonatomic) NSNumber *code;

-(VIPErrorCode*)initWithCode:(int)code andDescription:(NSString*)description;

@end

@implementation VIPErrorCode

-(VIPErrorCode*)initWithCode:(int)code andDescription:(NSString*)description
{
    self = [super init];
    if (self) {
        self.code = @(code);
        self.descriptionString = description;
    }
    return self;
}

@end

@implementation VIPError

// Error domain for this class for use in NSError
NSString * const VIPErrorDomain = @"com.votinginfoproject.whitelabel.error";

// Error codes used by this class and elsewhere in NSError

// Error codes starting with 100 directly correspond to status responses returned by the API
// See https://developers.google.com/civic-information/docs/data_guidelines#status


VIPErrorCode * _VIPNoStreetSegmentFound;
VIPErrorCode * _VIPAddressUnparseable;
VIPErrorCode * _VIPNoAddress;
VIPErrorCode * _VIPMultipleStreetSegmentsFound;
VIPErrorCode * _VIPElectionOver;
VIPErrorCode * _VIPElectionUnknown;
VIPErrorCode * _VIPInternalLookupError;

VIPErrorCode * _VIPGenericAPIError;
VIPErrorCode * _VIPNoValidElections;
VIPErrorCode * _VIPInvalidUserAddress;

VIPErrorCode * _VIPGeocoderError;

+ (VIPErrorCode*) VIPNoStreetSegmentFound { return _VIPNoStreetSegmentFound; }
+ (VIPErrorCode*) VIPAddressUnparseable { return _VIPAddressUnparseable; }
+ (VIPErrorCode*) VIPNoAddress { return _VIPNoAddress; }
+ (VIPErrorCode*) VIPMultipleStreetSegmentsFound { return _VIPMultipleStreetSegmentsFound; }
+ (VIPErrorCode*) VIPElectionOver { return _VIPElectionOver; }
+ (VIPErrorCode*) VIPElectionUnknown { return _VIPElectionUnknown; }
+ (VIPErrorCode*) VIPInternalLookupError { return _VIPInternalLookupError; }

+ (VIPErrorCode*) VIPGenericAPIError { return _VIPGenericAPIError; }
+ (VIPErrorCode*) VIPNoValidElections { return _VIPNoValidElections; }
+ (VIPErrorCode*) VIPInvalidUserAddress { return _VIPInvalidUserAddress; }

+ (VIPErrorCode*) VIPGeocoderError { return _VIPGeocoderError; }


// Definitions for the various possible responses from the voterInfo API
// Not translated because these are used internally and are explicit maps to the
//  voterInfo query v1 response
// See https://developers.google.com/civic-information/docs/data_guidelines#status
NSString * const APIResponseSuccess = @"success";
NSString * const APIResponseNoStreetSegmentFound = @"noStreetSegmentFound";
NSString * const APIAddressUnparseable = @"addressUnparseable";
NSString * const APIResponseNoAddressParameter = @"noAddressParameter";
NSString * const APIResponseMultipleStreetSegmentsFound = @"multipleStreetSegmentsFound";
NSString * const APIResponseElectionOver = @"electionOver";
NSString * const APIResponseElectionUnknown = @"electionUnknown";
NSString * const APIInternalLookupFailure = @"internalLookupFailure";

NSDictionary *_stringToErrorCode;


+ (void) initialize
{
    [super initialize];

    // We define strings this way, rather than via extern NSString* const because localized strings
    // defined like so:
    //  NSString * const foo = @"foo";
    //  NSString *localizedFoo = NSLocalizedString(foo, nil);
    // are not picked up by the genstrings tool.
    NSString *noStreetSegmentFound = NSLocalizedString(@"We found your address but we don't currently have any information about elections in your area.  Sorry :( .", nil);
    NSString *addressUnparseable = NSLocalizedString(@"Sorry, we couldn't understand the address you entered. Please reformat your address or provide more detail such as street name.", nil);
    NSString *noAddress = NSLocalizedString(@"No address provided", nil);
    NSString *multipleStreetSegmentsFound = NSLocalizedString(@"We can't find information for your address, but we have some for nearby ones", nil);
    NSString *electionOver = NSLocalizedString(@"This election is over.", nil);
    NSString *electionUnknown = NSLocalizedString(@"Unknown election. Please try again later.", nil);
    NSString *internalLookupError = NSLocalizedString(@"The server encountered an error while trying to retrieve your information. This is probably our fault, not yours.", nil);

    NSString *genericAPIError = NSLocalizedString(@"An unknown API error has occurred. Please try again later.", nil);
    NSString *noValidElections = NSLocalizedString(@"Sorry, there is no information for an upcoming election near you. Information about elections is generally available two to four weeks before the election date.", nil);
    NSString *invalidUserAddress = NSLocalizedString(@"Weird. It looks like we can't find your address. Maybe double check that it's right and try again.", nil);


    NSString *geocoderError = NSLocalizedString(@"Sorry, there are no location matches for this address. Try reformatting it or type a new one.", nil);


    _VIPNoStreetSegmentFound = [[VIPErrorCode alloc] initWithCode:101
                                                  andDescription:noStreetSegmentFound];
    _VIPAddressUnparseable = [[VIPErrorCode alloc] initWithCode:102
                                              andDescription:addressUnparseable];
    _VIPNoAddress = [[VIPErrorCode alloc] initWithCode:103
                                     andDescription:noAddress];
    _VIPMultipleStreetSegmentsFound = [[VIPErrorCode alloc] initWithCode:104
                                                       andDescription:multipleStreetSegmentsFound];
    _VIPElectionOver = [[VIPErrorCode alloc] initWithCode:105
                                        andDescription:electionOver];
    _VIPElectionUnknown = [[VIPErrorCode alloc] initWithCode:106
                                           andDescription:electionUnknown];
    _VIPInternalLookupError = [[VIPErrorCode alloc] initWithCode:107
                                               andDescription:internalLookupError];

    _VIPGenericAPIError = [[VIPErrorCode alloc] initWithCode:200
                                           andDescription:genericAPIError];
    _VIPNoValidElections = [[VIPErrorCode alloc] initWithCode:201
                                            andDescription:noValidElections];
    _VIPInvalidUserAddress = [[VIPErrorCode alloc] initWithCode:202
                                              andDescription:invalidUserAddress];

    _VIPGeocoderError = [[VIPErrorCode alloc] initWithCode:300
                                         andDescription:geocoderError];

    _stringToErrorCode = @{APIResponseNoStreetSegmentFound : _VIPNoStreetSegmentFound,
                           APIAddressUnparseable : _VIPAddressUnparseable,
                           APIResponseNoAddressParameter : _VIPNoAddress,
                           APIResponseMultipleStreetSegmentsFound : _VIPMultipleStreetSegmentsFound,
                           APIResponseElectionOver : _VIPElectionOver,
                           APIResponseElectionUnknown : _VIPElectionUnknown,
                           APIInternalLookupFailure : _VIPInternalLookupError};

}

+ (NSError*)errorWithCode:(VIPErrorCode*)errorCode
{
    if (!errorCode) {
        NSLog(@"Warning: Got nil argument for errorCode, this shouldn't happen!");
        errorCode = VIPError.VIPGenericAPIError;
    }
    return [NSError errorWithDomain:VIPErrorDomain
                               code:errorCode.code.intValue
                           userInfo:@{NSLocalizedDescriptionKey: errorCode.descriptionString}];
}

+ (NSError*) statusToError:(NSString*)status
{
    VIPErrorCode *errorCode = [_stringToErrorCode objectForKey:status];
    return errorCode == nil ? nil : [VIPError errorWithCode:errorCode];
}

@end
