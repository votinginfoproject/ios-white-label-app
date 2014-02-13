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
    NSURL* url = [NSURL URLWithString:self.urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    if (url && request) {
        NSLog(@"Loading: %@", self.urlString);
        [_webView loadRequest:request];
    } else {
        [self showErrorAlert];
    }
}

- (void) showErrorAlert
{
    NSString *message = [NSString stringWithFormat:@"%@: %@",
                         NSLocalizedString(@"Unable to load URL", nil),
                         self.urlString];
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
