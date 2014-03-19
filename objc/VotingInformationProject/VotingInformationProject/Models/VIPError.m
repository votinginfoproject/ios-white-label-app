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


VIPErrorCode * _NoStreetSegmentFound;
VIPErrorCode * _AddressUnparseable;
VIPErrorCode * _NoAddress;
VIPErrorCode * _MultipleStreetSegmentsFound;
VIPErrorCode * _ElectionOver;
VIPErrorCode * _ElectionUnknown;
VIPErrorCode * _InternalLookupError;

VIPErrorCode * _GenericAPIError;
VIPErrorCode * _NoValidElections;
VIPErrorCode * _InvalidUserAddress;

VIPErrorCode * _GeocoderError;

+ (VIPErrorCode*) NoStreetSegmentFound { return _NoStreetSegmentFound; }
+ (VIPErrorCode*) AddressUnparseable { return _AddressUnparseable; }
+ (VIPErrorCode*) NoAddress { return _NoAddress; }
+ (VIPErrorCode*) MultipleStreetSegmentsFound { return _MultipleStreetSegmentsFound; }
+ (VIPErrorCode*) ElectionOver { return _ElectionOver; }
+ (VIPErrorCode*) ElectionUnknown { return _ElectionUnknown; }
+ (VIPErrorCode*) InternalLookupError { return _InternalLookupError; }

+ (VIPErrorCode*) GenericAPIError { return _GenericAPIError; }
+ (VIPErrorCode*) NoValidElections { return _NoValidElections; }
+ (VIPErrorCode*) InvalidUserAddress { return _InvalidUserAddress; }

+ (VIPErrorCode*) GeocoderError { return _GeocoderError; }


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
    NSString *noStreetSegmentFound = NSLocalizedString(@"We found your address but we don't currently have any information about elections in your area.  Sorry :( .",
        @"Error message displayed when no elections information found for address");
    NSString *addressUnparseable = NSLocalizedString(@"Sorry, we couldn't understand the address you entered. Please reformat your address or provide more detail such as street name.",
        @"Error message displayed when address cannot be read as entered");
    NSString *noAddress = NSLocalizedString(@"No address provided",
                                            @"Error message displayed when no address entered by user");
    NSString *multipleStreetSegmentsFound = NSLocalizedString(@"We can't find information for your address, but we have some for nearby ones",
        @"Error message displayed when address not found, but nearby locations were returned");
    NSString *electionOver = NSLocalizedString(@"This election is over.",
        @"Error message displayed when election has ended");
    NSString *electionUnknown = NSLocalizedString(@"Unknown election. Please try again later.",
        @"Error message displayed when selected election cannot be found");
    NSString *internalLookupError = NSLocalizedString(@"The server encountered an error while trying to retrieve your information. This is probably our fault, not yours.",
        @"Error message displayed when server error occurs while retrieving information");
    NSString *genericAPIError = NSLocalizedString(@"An unknown API error has occurred. Please try again later.",
        @"Error message displayed when generic API error encountered while looking up information");
    NSString *noValidElections = NSLocalizedString(@"Sorry, there is no information for an upcoming election near you. Information about elections is generally available two to four weeks before the election date.",
        @"Error message displayed when no valid elections found near address");
    NSString *invalidUserAddress = NSLocalizedString(@"Weird. It looks like we can't find your address. Maybe double check that it's right and try again.",
        @"Error message displayed when address user entered cannot be found");
    NSString *geocoderError = NSLocalizedString(@"Sorry, there are no location matches for this address. Try reformatting it or type a new one.",
        @"Error message displayed on geocoder error (address user entered cannot be found)");


    _NoStreetSegmentFound = [[VIPErrorCode alloc] initWithCode:101
                                                  andDescription:noStreetSegmentFound];
    _AddressUnparseable = [[VIPErrorCode alloc] initWithCode:102
                                              andDescription:addressUnparseable];
    _NoAddress = [[VIPErrorCode alloc] initWithCode:103
                                     andDescription:noAddress];
    _MultipleStreetSegmentsFound = [[VIPErrorCode alloc] initWithCode:104
                                                       andDescription:multipleStreetSegmentsFound];
    _ElectionOver = [[VIPErrorCode alloc] initWithCode:105
                                        andDescription:electionOver];
    _ElectionUnknown = [[VIPErrorCode alloc] initWithCode:106
                                           andDescription:electionUnknown];
    _InternalLookupError = [[VIPErrorCode alloc] initWithCode:107
                                               andDescription:internalLookupError];

    _GenericAPIError = [[VIPErrorCode alloc] initWithCode:200
                                           andDescription:genericAPIError];
    _NoValidElections = [[VIPErrorCode alloc] initWithCode:201
                                            andDescription:noValidElections];
    _InvalidUserAddress = [[VIPErrorCode alloc] initWithCode:202
                                              andDescription:invalidUserAddress];

    _GeocoderError = [[VIPErrorCode alloc] initWithCode:300
                                         andDescription:geocoderError];

    _stringToErrorCode = @{APIResponseNoStreetSegmentFound : _NoStreetSegmentFound,
                           APIAddressUnparseable : _AddressUnparseable,
                           APIResponseNoAddressParameter : _NoAddress,
                           APIResponseMultipleStreetSegmentsFound : _MultipleStreetSegmentsFound,
                           APIResponseElectionOver : _ElectionOver,
                           APIResponseElectionUnknown : _ElectionUnknown,
                           APIInternalLookupFailure : _InternalLookupError};

}

+ (NSError*)errorWithCode:(VIPErrorCode*)errorCode
{
    if (!errorCode) {
        NSLog(@"Warning: Got nil argument for errorCode, this shouldn't happen!");
        errorCode = VIPError.GenericAPIError;
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
