//
//  VIPError.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 3/4/14.
//

#import <Foundation/Foundation.h>

@interface VIPError : NSObject

// Error domain for this class for use in NSError
extern NSString * const VIPErrorDomain;

// Error codes used by this class and elsewhere in NSError
// Get localized string descriptions with
//  + (NSString*)localizedDescriptionForErrorCode:
extern NSUInteger const VIPNoValidElections;
extern NSUInteger const VIPInvalidUserAddress;
extern NSUInteger const VIPAddressUnparseable;
extern NSUInteger const VIPNoAddress;
extern NSUInteger const VIPElectionUnknown;
extern NSUInteger const VIPElectionOver;
extern NSUInteger const VIPGenericAPIError;
extern NSUInteger const VIPGeocoderError;

// Definitions for the various possible responses from the voterInfo API
extern NSString * const APIResponseSuccess;
extern NSString * const APIResponseElectionOver;
extern NSString * const APIResponseElectionUnknown;
extern NSString * const APIResponseNoStreetSegmentFound;
extern NSString * const APIResponseMultipleStreetSegmentsFound;
extern NSString * const APIResponseNoAddressParameter;

/**
 *  Returns a statically allocated description for the errorCode
 *
 *  @param errorCode One of the VIP error codes defined in this header file
 *  @return NSString localized description for the error. Returns VIPGenericAPIError if no match.
 */
+ (NSString*)localizedDescriptionForAPIErrorCode:(NSUInteger)errorCode;

/**
 *  Get an NSError object for the given errorCode
 *
 *  @param errorCode One of the extern NSUIntegers defined in this header.
 *
 *  @return NSError* with domain, code and localizedDescription set.
 *          Defaults to VIPGenericAPIError errorCode not found.
 */
+ (NSError*)errorWithCode:(NSUInteger)errorCode;

@end
