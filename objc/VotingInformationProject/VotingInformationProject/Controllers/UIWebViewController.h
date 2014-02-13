//
//  UIWebViewController.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/13/14.
//

#import <UIKit/UIKit.h>

@interface UIWebViewController : UIViewController <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) NSString* urlString;

@end
