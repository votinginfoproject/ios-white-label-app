//
//  VIPViewController.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 3/18/14.
//

#import "VIPViewController.h"
#import "ScreenMacros.h"
#import "VIPColor.h"

@interface VIPViewController ()

@end

@implementation VIPViewController

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

    // Set background image, scaled to view size
    NSString *imageName = @"Default_background";
    if (IS_WIDESCREEN) {
        imageName = @"Default_background-568";
    }
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:imageName] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];

    UIColor *navBarBGColor = [VIPColor navBarBackgroundColor];
    self.navigationController.navigationBar.barTintColor = navBarBGColor;

    /* i18n Sample Demo
     Use number formatter/date formatter/etc for numbers, dates, etc. Controlled by:
        Settings.app->General->International->Region Format
     Control language settings via:
        Settings.app->General->International->Language
     
    Second argument to NSLocalizedString is a comment to be provided in the Localizable.strings file
        for translator context
    
    genstrings is an xcode command line tool for generating a Localizable.strings file from
     all NSLocalizedString calls in your app.
     https://developer.apple.com/library/mac/documentation/Darwin/Reference/ManPages/man1/genstrings.1.html
     http://blog.spritebandits.com/2012/01/25/ios-iphone-app-localization-genstrings-tips/
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];

    NSString *oneMillion = [numberFormatter stringFromNumber:@(1000000)];
    self.localizationLabel.text = [NSString stringWithFormat:NSLocalizedString(@"NUMBER: %@", nil), oneMillion];
    */

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
