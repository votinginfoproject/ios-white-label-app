//
//  AppSettings.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 3/14/14.
//

#import <Foundation/Foundation.h>

@interface AppSettings : NSObject

+ (NSDictionary*)settings;

/**
 *  Get text for UI from settings.plist
 *
 *  @param key The settings.plist key to pull the text from
 *
 *  @return The text from the dictionary, or the key name if key value does not exist.
 *          If the key value does not exist, also prints a message to NSLog with instructions.
 */
+ (NSString*)UIStringForKey:(NSString*)key;

+ (id)valueForKey:(NSString*)key withDefault:(id)defaultValue;

@end
