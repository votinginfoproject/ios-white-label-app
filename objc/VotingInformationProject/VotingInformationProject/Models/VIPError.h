//
//  VIPError.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 3/4/14.
//

#import <Foundation/Foundation.h>

@interface VIPErrorCode : NSObject

@property (nonatomic, readonly) NSString *descriptionString;
@property (nonatomic, readonly) NSNumber *code;

@end

@interface VIPError : NSObject

// Error domain for this class for use in NSError
extern NSString * const VIPErrorDomain;

//// Error codes used by this class and elsewhere in NSError
//extern VIPErrorCode * VIPNoStreetSegmentFound;
//extern VIPErrorCode * VIPAddressUnparseable;
//extern VIPErrorCode * VIPNoAddress;
//extern VIPErrorCode * VIPMultipleStreetSegmentsFound;
//extern VIPErrorCode * VIPElectionOver;
//extern VIPErrorCode * VIPElectionUnknown;
//extern VIPErrorCode * VIPInternalLookupError;
//
//extern VIPErrorCode * VIPGenericAPIError;
//extern VIPErrorCode * VIPNoValidElections;
//extern VIPErrorCode * VIPInvalidUserAddress;
//
//extern VIPErrorCode * VIPGeocoderError;


+ (VIPErrorCode*)VIPNoStreetSegmentFound;
+ (VIPErrorCode*)VIPAddressUnparseable;
+ (VIPErrorCode*)VIPNoAddress;
+ (VIPErrorCode*)VIPMultipleStreetSegmentsFound;
+ (VIPErrorCode*)VIPElectionOver;
+ (VIPErrorCode*)VIPElectionUnknown;
+ (VIPErrorCode*)VIPInternalLookupError;

+ (VIPErrorCode*)VIPGenericAPIError;
+ (VIPErrorCode*)VIPNoValidElections;
+ (VIPErrorCode*)VIPInvalidUserAddress;

+ (VIPErrorCode*)VIPGeocoderError;

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
 *          Defaults to VIPGenericAPIError errorCode not found.
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
