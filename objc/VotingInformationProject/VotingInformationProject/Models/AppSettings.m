//
//  AppSettings.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 3/14/14.
//

#import "AppSettings.h"

@implementation AppSettings

+ (NSDictionary*)settings
{
    static NSDictionary *appSettingsDict;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *appSettingsPath = [[NSBundle mainBundle] pathForResource:@"settings" ofType:@"plist"];
        appSettingsDict = [[NSDictionary alloc] initWithContentsOfFile:appSettingsPath];
    });
    return appSettingsDict;
}

+ (NSString*)UIStringForKey:(NSString *)key
{
    NSString *uiString = [[self settings] valueForKey:key];
    if (!uiString) {
        uiString = key;
        NSLog(@"Add value for key %@ in settings.plist", key);
    }
    return uiString;
}

+ (id)valueForKey:(NSString*)key withDefault:(id)defaultValue
{
    id value = [[self settings] objectForKey:key];
    return value ? value : defaultValue;
}

@end
