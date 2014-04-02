//
//  VIPViewController.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 3/18/14.
//

#import "VIPViewController.h"
#import "ScreenMacros.h"
#import "VIPColor.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"

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
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self sendGAScreenHit];
}

- (void)sendGAScreenHit
{
    if ([self.screenName length] > 0) {
        id tracker = [[GAI sharedInstance] defaultTracker];
        // This screen name value will remain set on the tracker and sent with
        // hits until it is set to a new value or to nil.
        [tracker set:kGAIScreenName
               value:self.screenName];
        
        [tracker send:[[GAIDictionaryBuilder createAppView] build]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
