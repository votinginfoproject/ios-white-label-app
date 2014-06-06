//
//  DirectionsListViewController.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 4/10/14.
//

#import "VIPViewController.h"

@class DirectionsListViewController;

@protocol DirectionsListViewControllerDelegate <NSObject>

- (void)directionsListViewControllerDidClose:(DirectionsListViewController*)controller
                          withDirectionsJson:(NSDictionary*)json;

@end

@interface DirectionsListViewController : VIPViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>

@property (weak, nonatomic) id <DirectionsListViewControllerDelegate> delegate;
@property (strong, nonatomic) NSString *sourceAddress;
@property (strong, nonatomic) NSString *destinationAddress;

@end
