//
//  VIPError.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 3/4/14.
//

#import <Foundation/Foundation.h>

/** Encapsulates an error code and description.
 *  Every instance of this class is meant to be a built-in singleton, so all properties are readonly
 */
@interface VIPErrorCode : NSObject

/** Descriptive string for the error (note "description" is defined by NSObject) */
@property (nonatomic, readonly) NSString *descriptionString;

/** Unique numeric identifier */
@property (nonatomic, readonly) NSNumber *code;

@end

@interface VIPError : NSObject

// Error domain for this class for use in NSError
extern NSString * const VIPErrorDomain;

// These error codes directly correspond to responses from the Civic Info API
// See https://developers.google.com/civic-information/docs/data_guidelines#status
+ (VIPErrorCode*)NoStreetSegmentFound;
+ (VIPErrorCode*)AddressUnparseable;
+ (VIPErrorCode*)NoAddress;
+ (VIPErrorCode*)MultipleStreetSegmentsFound;
+ (VIPErrorCode*)ElectionOver;
+ (VIPErrorCode*)NoStreetSegmentFound;
+ (VIPErrorCode*)InternalLookupError;

+ (VIPErrorCode*)GenericAPIError;
+ (VIPErrorCode*)NoValidElections;
+ (VIPErrorCode*)InvalidUserAddress;

+ (VIPErrorCode*)GeocoderError;

// Definitions for the various possible responses from the voterInfo API
extern NSString * const APIResponseSuccess;
extern NSString * const APIResponseNoStreetSegmentFound;
extern NSString * const APIAddressUnparseable;
extern NSString * const APIResponseNoAddressParameter;
extern NSString * const APIResponseMultipleStreetSegmentsFound;
extern NSString * const APIResponseElectionOver;
extern NSString * const APIResponseElectionUnknown;
extern NSString * const APIInternalLookupFailure;


/**
 *  Get an NSError object for the given errorCode
 *
 *  @param errorCode One of the VIPErrorCode objects defined in this header.
 *
 *  @return NSError* with domain, code and localizedDescription set.
 *          Defaults to GenericAPIError errorCode not found.
 */
+ (NSError*)errorWithCode:(VIPErrorCode*)errorCode;

/**
 *  Return an NSError object based on the status strings from the voterInfo API query
 *
 *  @param status NSString status from voterInfo API query
 *  @return nil on success, or NSError with localizedDescription property set to a helpful message
 *      if something went wrong
 */
+ (NSError*) statusToError:(NSString*)status;

@end
