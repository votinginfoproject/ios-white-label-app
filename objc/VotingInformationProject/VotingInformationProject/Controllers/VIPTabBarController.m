//
//  VIPTabBarController.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/7/14.
//  
//

#import "VIPTabBarController.h"

#import "Election+API.h"
#import "VIPUserDefaultsKeys.h"

@interface VIPTabBarController ()

@end

@implementation VIPTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupTabBarImages];


    self.elections = nil;
    self.currentElection = nil;
    self.currentParty = nil;

    // Check if ElectionID/Address/Party exist in local store. If they do, load from there instead
    //  of showing modal window
    [self loadVIPDataFromCache];
}

- (void)setupTabBarImages
{
    // Selected image names are at imageName + @"-active"
    // Ex selected image for TabBar_ballot is TabBar_ballot-active
    NSArray *imageNames = @[@"TabBar_ballot",
                            @"TabBar_details",
                            @"TabBar_polling"];
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

- (BOOL)isVIPDataAvailable
{
    return self.currentElection ? YES : NO;
}

/* Loading the data from cache allows us to skip the "Select address/party" modal
 * when we restore the app from a saved state
 */
- (void)loadVIPDataFromCache
{
    // TODO: Reimplement with hydration via stored UserElection json object
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    NSString *party = [defaults stringForKey:USER_DEFAULTS_PARTY];
    self.currentParty = party;

    NSError* error = nil;
    NSString *currentJson = [defaults objectForKey:USER_DEFAULTS_JSON];
    UserElection *votingInfo = [[UserElection alloc] initWithString:currentJson error:&error];
    if (!error) {
        if (![votingInfo.election isExpired]) {
            NSLog(@"Loading election %@ from cache", votingInfo.election.name);
            self.currentElection = votingInfo;
        }
    }
}

@end
