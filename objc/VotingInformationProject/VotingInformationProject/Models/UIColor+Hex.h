//
//  UIColor+Hex.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 3/19/14.
//

#import <UIKit/UIKit.h>

@interface UIColor (Hex)

/**
 *  Create color from hex string
 *
 *  Calls colorWithHexString:alpha: internally, see that method for
 *  param/return details
 *
 *  @param hexString
 *
 *  @return RGB UIColor
 */
+ (UIColor*)colorWithHexString:(NSString*)hexString;

/**
 *  Create color from hex string with passed alpha
 *
 *  @param hexString Hex string of the form '#RRGGBB' or '0xRRGGBB'
 *                   Leading/trailing whitespace are trimmed.
 *  @param alpha     Alpha value between 0-1
 *
 *  @return RGB UIColor representation or [UIColor clearColor] if
 *          not able to create a valid representation
 */
+ (UIColor*)colorWithHexString:(NSString*)hexString
                         alpha:(CGFloat)alpha;

@end
