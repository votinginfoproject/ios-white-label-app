//
//  VIPTableViewController.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 3/18/14.
//

#import "VIPTableViewController.h"
#import "ScreenMacros.h"
#import "VIPColor.h"

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

    UIColor *navBarBGColor = [VIPColor navBarBackgroundColor];
    self.navigationController.navigationBar.barTintColor = navBarBGColor;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
