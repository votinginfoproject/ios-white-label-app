//
//  VIPColor.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 3/19/14.
//

#import "VIPColor.h"
#import "UIColor+Hex.h"
#import "AppSettings.h"

@implementation VIPColor

// TODO: Add cache for these colors or make them singletons
// TODO: Make a function that abstracts these color functions.
//          Something like -(UIColor*)readColor:(NSString*)dictKey default:(NSString*)hexValue ?

+ (UIColor*)color:(UIColor *)color withAlpha:(CGFloat)alpha
{
    CGFloat red, green, blue, oldalpha;
    BOOL success = [color getRed:&red green:&green blue:&blue alpha:&oldalpha];
    if (success) {
        return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    }
    return color;
}

+ (UIColor*)primaryTextColor
{
    NSString *hexColor = [[AppSettings settings] valueForKey:@"primaryTextColor"];
    if (!hexColor) {
        return [UIColor whiteColor];
    }
    return [UIColor colorWithHexString:hexColor];
}

+ (UIColor*)secondaryTextColor
{
    NSString *hexColor = [[AppSettings settings] valueForKey:@"secondaryTextColor"];
    if (!hexColor) {
        hexColor = @"0x60c9f8";
    }
    return [UIColor colorWithHexString:hexColor];
}

+ (UIColor*)navBarBackgroundColor
{
    NSString *hexColor = [[AppSettings settings] valueForKey:@"navBarBackgroundColor"];
    if (!hexColor) {
        hexColor = @"#162550";
    }
    return [UIColor colorWithHexString:hexColor];
}

+ (UIColor*)navBarTextColor
{
    NSString *hexColor = [[AppSettings settings] valueForKey:@"navBarBackgroundColor"];
    if (!hexColor) {
        return [self secondaryTextColor];
    }
    return [UIColor colorWithHexString:hexColor];
}

+ (UIColor*)tabBarBackgroundColor
{
    NSString *hexColor = [[AppSettings settings] valueForKey:@"tabBarBackgroundColor"];
    if (!hexColor) {
        //return [UIColor lightGrayColor];
        hexColor = @"#78a3c6";
    }
    return [UIColor colorWithHexString:hexColor];
}

+ (UIColor*)tabBarTextColor
{
    NSString *hexColor = [[AppSettings settings] valueForKey:@"tabBarTextColor"];
    if (!hexColor) {
        return [UIColor whiteColor];
    }
    return [UIColor colorWithHexString:hexColor];
}

+ (UIColor*)tabBarSelectedTextColor
{
    NSString *hexColor = [[AppSettings settings] valueForKey:@"tabBarSelectedTextColor"];
    if (!hexColor) {
        return [UIColor colorWithHexString:@"072C66"];
    }
    return [UIColor colorWithHexString:hexColor];
}

@end
