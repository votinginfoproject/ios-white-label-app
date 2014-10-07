//
//  VIPModel.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 10/6/14.
//

#import "JSONModel.h"

@interface VIPModel : JSONModel

/**
 *  Dictionary key is the object property name, conformant to key paths,
 *  Dictionary value is a human readable, localized string to description of the property
 *      to display in the UI
 *
 *  @return a NSDictionary A dictionary of object properties to display
 */
+ (NSDictionary*)propertyList;

/**
 Gets a subset of the properties of contest and returns them as an array,
 where each object in the array is an NSDictionary of hte following form:

 Default property list returns id and name (if available). Override in subclass,
 See Contest+API for an example

 @{
 "title": <NSLocalizedString of the title to display for this property>
 "data": <The data to display, as an NSString
 }

 @return NSMutableArray of NSDictionaries of the form specified above
 */
- (NSMutableArray*)getProperties;

@end
