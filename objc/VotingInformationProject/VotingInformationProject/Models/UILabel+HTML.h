//
//  UILabel+HTML.h
//
//  Created by Andrew Fink on 4/10/14.
//

#import <UIKit/UIKit.h>

@interface UILabel (HTML)

- (void) setHtmlText:(NSString*)html;

- (void) setHtmlText:(NSString*)html
      withAttributes:(NSDictionary*)attributes;

@end
