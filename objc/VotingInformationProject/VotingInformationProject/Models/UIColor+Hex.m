//
//  UIColor+Hex.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 3/19/14.
//

#import "UIColor+Hex.h"

@implementation UIColor (Hex)

+ (UIColor*)colorWithHexString:(NSString *)hexString
{
    return [self colorWithHexString:hexString alpha:1.0];
}

+ (UIColor*)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha
{
    NSScanner *hexScanner = [NSScanner scannerWithString:hexString];
    // Skip that hashbang and trim whitespace
    NSMutableCharacterSet *skippedChars = [NSMutableCharacterSet characterSetWithCharactersInString:@"#"];
    [skippedChars formUnionWithCharacterSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [hexScanner setCharactersToBeSkipped:skippedChars];
    unsigned int hexColor;
    BOOL success = [hexScanner scanHexInt:&hexColor];
    if (!success) {
        return [UIColor clearColor];
    }

    CGFloat red = ((hexColor & 0xFF0000) >> 16) / 255.0f;
    CGFloat green = ((hexColor & 0x00FF00) >> 8) / 255.0f;
    CGFloat blue = (hexColor & 0x0000FF) / 255.0f;

    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

@end
