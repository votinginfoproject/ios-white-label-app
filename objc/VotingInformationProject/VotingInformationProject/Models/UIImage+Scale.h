//
//  UIImage+Scale.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 3/20/14.
//

#import <UIKit/UIKit.h>

@interface UIImage (Scale)

/**
 *  Scale a UIImage to the new absolute pixel bounds
 *
 *  @param image   UIImage to scale
 *  @param newSize New scaled size in pixels as a CGSize
 *
 *  @return New scaled UIImage or nil if not able 
 */
+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;

@end
