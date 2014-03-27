//
//  AppDelegate.h
//  VotingInformationProject
//
//  Created by Bennet Huber on 1/17/14.
//  
//

#import <UIKit/UIKit.h>

#import "GoogleMaps/GoogleMaps.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSManagedObjectContext *moc;

- (NSURL *)applicationDocumentsDirectory;

@end
