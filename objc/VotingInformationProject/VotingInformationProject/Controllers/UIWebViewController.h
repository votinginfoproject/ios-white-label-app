//
//  UIWebViewController.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/13/14.
//

#import <UIKit/UIKit.h>

/**
 UIWebViewController for displaying web links via push segue
 
 Steps for using:
 1. Create push segue from action to UIWebView by ctrl+drag from action
    to UIWebView in storyboard
 2. Ensure push segue has the name "WebViewSegue"
 3. Set urlString property from the prepareForSegue message of the source view controller
    Search this project for #pragma mark - UIWebViewController example (in ContactsSearchVC)
 */
@interface UIWebViewController : UIViewController <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) NSString* urlString;

@end
