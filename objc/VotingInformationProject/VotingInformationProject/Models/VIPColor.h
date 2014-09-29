//
//  VIPColor.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 3/19/14.
//

#import <Foundation/Foundation.h>

/*
 * The colors for the VIP app. Can be customized by adding the key/value pair
 * indicated in each method's docstring to settings.plist
 */
@interface VIPColor : NSObject

/*
 * Returns a new instance of the existing color with the modified alpha
 *
 * @param color The color to modify, should be in RGB space
 * @param alpha The alpha to set the new color to. Should be [0-1].
 *
 * @return A new UIColor with alpha modified.
 */
+ (UIColor *)color:(UIColor*)color
         withAlpha:(CGFloat)alpha;

/*
 * key: tableHeaderColor
 * value: A hex string, i.e. '#FFFFFF'
 */
+ (UIColor*) tableHeaderColor;

/*
 * key: navBarTextColor
 * value: A hex string, i.e. '#FFFFFF'
 */
+ (UIColor*) navBarTextColor;

/*
 * key: navBarBackgroundColor
 * value: A hex string, i.e. '#FFFFFF'
 */
+ (UIColor*) navBarBackgroundColor;

/*
 * key: tabBarBackgroundColor
 * value: A hex string, i.e. '#FFFFFF'
 */
+ (UIColor*) tabBarBackgroundColor;

/*
 * key: tabBarTextColor
 * value: A hex string, i.e. '#FFFFFF'
 */
+ (UIColor*) tabBarTextColor;

/*
 * key: tabBarSelectedTextColor
 * value: A hex string, i.e. '#FFFFFF'
 */
+ (UIColor*) tabBarSelectedTextColor;

/*
 * key: primaryTextColor
 * value: A hex string, i.e. '#FFFFFF'
 */
+ (UIColor*) primaryTextColor;

/*
 * key: secondaryTextColor
 * value: A hex string, i.e. '#FFFFFF'
 */
+ (UIColor*) secondaryTextColor;

/*
 * key: linkColor
 * value: A hex string, i.e. '#FFFFFF'
 */
+ (UIColor*) linkColor;

@end
