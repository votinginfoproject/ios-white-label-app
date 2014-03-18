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

@end
