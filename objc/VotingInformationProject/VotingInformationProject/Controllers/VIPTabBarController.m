//
//  VIPTabBarController.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/7/14.
//  
//

#import "VIPTabBarController.h"

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

- (BOOL)isVIPDataAvailable
{
    return self.elections && self.currentElection;
}

/* Loading the data from cache allows us to skip the "Select address/party" modal
 * when we restore the app from a saved state
 */
- (void)loadVIPDataFromCache
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *address = [defaults stringForKey:USER_DEFAULTS_STORED_ADDRESS];
    NSString *electionId = [defaults stringForKey:USER_DEFAULTS_ELECTION_ID];
    NSString *party = [defaults stringForKey:USER_DEFAULTS_PARTY];

    UserAddress *userAddress = [UserAddress MR_findFirstByAttribute:@"address" withValue:address];
    NSArray *elections = [Election MR_findByAttribute:@"userAddress"
                                            withValue:userAddress
                                           andOrderBy:@"date"
                                            ascending:YES];
    for (Election *election in elections) {
        if ([election.electionId isEqualToString:electionId]) {
            self.currentParty = party;
            self.currentElection = election;
            self.elections = elections;
        }
    }
}

@end
