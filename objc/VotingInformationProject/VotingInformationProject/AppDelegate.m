//
//  AppDelegate.m
//  VotingInformationProject
//
//  Created by Bennet Huber on 1/17/14.
//  
//

#import "AppDelegate.h"
#import "AppSettings.h"
#import "VIPColor.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Initialize Core Data Stack via MagicalRecord
    [MagicalRecord setupCoreDataStack];
    // Use this reference for all MagicalRecord save operations to avoid race conditions
    //  and other errors.
    self.moc = [NSManagedObjectContext MR_defaultContext];

    // Load GoogleMaps API Key from file
    // Default key provided in repo is azaveadev@azavea.com key
    // Instructions on using your own key are in the README: necessary if you change the app bundle identifier
    [GMSServices provideAPIKey:[[AppSettings settings] objectForKey:@"GoogleMapsAPIKey"]];

    // Sets color of navigation bars
    self.window.tintColor = [VIPColor navBarTextColor];

    // Global tab bar styling
    //[[UITabBar appearance] setTranslucent:NO];
    [[UITabBar appearance] setBarTintColor:[VIPColor tabBarBackgroundColor]];
    UIColor *titleNormalColor = [VIPColor tabBarTextColor];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: titleNormalColor}
                                             forState:UIControlStateNormal];
    UIColor *titleHighlightedColor = [VIPColor tabBarSelectedTextColor];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: titleHighlightedColor}
                                             forState:UIControlStateSelected];

    // Table View Cell Appearance
    [[UITableView appearance] setBackgroundColor:[UIColor clearColor]];
    [[UITableViewCell appearance] setBackgroundColor:[VIPColor color:[VIPColor primaryTextColor] withAlpha:0.25]];

    [[UILabel appearanceWhenContainedIn:[UITableViewCell class], nil] setTextColor:[VIPColor primaryTextColor]];
    // Re-override the label background color in UITableViewCell. Apparently the call that sets
    // the UITableViewCell background color above also sets it for child elements?
    [[UILabel appearanceWhenContainedIn:[UITableViewCell class], nil] setBackgroundColor:[UIColor clearColor]];

    // Segmented control Appearance
    [[UISegmentedControl appearance] setTintColor:[VIPColor primaryTextColor]];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [MagicalRecord cleanUp];
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
