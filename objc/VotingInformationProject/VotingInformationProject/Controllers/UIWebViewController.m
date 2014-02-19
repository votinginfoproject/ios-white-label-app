//
//  UIWebViewController.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/13/14.
//

#import "UIWebViewController.h"

@interface UIWebViewController ()

@end

@implementation UIWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	// Do any additional setup after loading the view.
    NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
    if (self.url && request) {
        NSLog(@"Loading: %@", self.url);
        [_webView loadRequest:request];
    } else {
        [self showErrorAlert];
    }
}

/**
 Show a simple alert message on error
 of the form: "Unable to load URL: <self.urlString>"
 */
- (void) showErrorAlert
{
    NSString *message = [NSString stringWithFormat:@"%@: %@",
                         NSLocalizedString(@"Unable to load URL", nil),
                         self.url];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"Ok", nil)
                                          otherButtonTitles:nil];
    [alert show];
}

#pragma mark - UIWebViewDelegate

- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self showErrorAlert];
}

- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    // No way to detect the HTTP status in a webview. If we want to do this later,
    // we will need to manually initiate the nsurlrequest in webViewDidStartLoad
    // See: http://stackoverflow.com/questions/2236407/how-to-detect-and-handle-http-error-codes-in-uiwebview
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
