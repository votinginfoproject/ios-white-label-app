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

    UIImage *homeImage = [UIImage imageNamed:@"NavigationBar_home"];
    UIBarButtonItem *homeButton = [[UIBarButtonItem alloc] initWithImage:homeImage
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(didTapBackButton:)];
    self.navigationItem.leftBarButtonItem = homeButton;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupTabBarImages
{
    // Selected image names are at imageName + @"-active"
    // Ex selected image for TabBar_ballot is TabBar_ballot-active
    NSArray *imageNames = @[@"TabBar_ballot",
                            @"TabBar_details",
                            @"TabBar_polling",
                            @"TabBar_more"];
    NSUInteger index = 0;
    UITabBar *tabBar = self.tabBar;
    for (UITabBarItem* tabBarItem in tabBar.items) {
        NSString *imageName = imageNames[index];
        UIImage *image = [UIImage imageNamed:imageName];
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

        NSString *selectedImageName = [imageName stringByAppendingString:@"-active"];
        UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
        selectedImage = [selectedImage
                         imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

        tabBarItem.image = image;
        tabBarItem.selectedImage = selectedImage;
        index++;
    }
}

- (void)didTapBackButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
