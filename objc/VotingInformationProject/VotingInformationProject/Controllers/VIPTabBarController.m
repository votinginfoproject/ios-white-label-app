//
//  VIPTabBarController.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/7/14.
//  
//

#import "VIPTabBarController.h"

@interface VIPTabBarController ()

@end

@implementation VIPTabBarController

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
    [self setupTabBarImages];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupTabBarImages
{
    NSArray *selectedImageNames = @[@"TabBar_ballot-active",
                                    @"TabBar_details-active",
                                    @"TabBar_polling-active",
                                    @"TabBar_more-active"];
    NSUInteger index = 0;
    UITabBar *tabBar = self.tabBar;
    for (UITabBarItem* tabBarItem in tabBar.items) {
        NSString *selectedImageName = selectedImageNames[index];
        UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
        selectedImage = [selectedImage
                         imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        tabBarItem.selectedImage = selectedImage;
        index++;
    }
}

@end
