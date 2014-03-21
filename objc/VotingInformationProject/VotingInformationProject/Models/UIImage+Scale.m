//
//  UIImage+Scale.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 3/20/14.
//

#import "UIImage+Scale.h"

@implementation UIImage (Scale)

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
