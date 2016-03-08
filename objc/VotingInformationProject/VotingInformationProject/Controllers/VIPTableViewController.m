//
//  VIPTableViewController.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 3/18/14.
//

#import "VIPTableViewController.h"
#import "ScreenMacros.h"
#import "VIPColor.h"
#import "VIPFeedbackView.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"

@interface VIPTableViewController ()

@end

@implementation VIPTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:image];
    [self.tableView setOpaque:NO];

    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self sendGAScreenHit];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)sendGAScreenHit
{
    if ([self.screenName length] > 0) {
        id tracker = [[GAI sharedInstance] defaultTracker];
        // This screen name value will remain set on the tracker and sent with
        // hits until it is set to a new value or to nil.
        [tracker set:kGAIScreenName
               value:self.screenName];
        
        [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    }
}

@end
