//
//  UILabel+HTML.m
//
//  Created by Andrew Fink on 4/10/14.
//

#import "UILabel+HTML.h"

@implementation UILabel (HTML)

- (void) setHtmlText: (NSString*) html
{
    [self setHtmlText:html withAttributes:nil];
}

- (void)setHtmlText:(NSString *)html withAttributes:(NSDictionary *)attributes
{
    NSDictionary *options = @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType };
    NSError *error = nil;
    NSMutableAttributedString *attributedText =
    [[NSMutableAttributedString alloc]
     initWithData: [html dataUsingEncoding:NSUTF8StringEncoding]
     options: options
     documentAttributes: nil
     error: &error];
    if (error) {
        NSLog(@"Unable to parse label text: %@", error);
        return;
    }
    if (attributes) {
        NSRange range = NSMakeRange(0, [attributedText length]);
        [attributedText addAttributes:attributes range:range];
    }
    self.attributedText = attributedText;
}

@end
