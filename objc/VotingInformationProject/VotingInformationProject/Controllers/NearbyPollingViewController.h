//
//  NearbyPollingViewController.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 1/22/14.
//  
//

#import <UIKit/UIKit.h>
#import "GoogleMaps/GoogleMaps.h"

#import "VIPViewController.h"
#import "DirectionsListViewController.h"
#import "ContactsSearchViewControllerDelegate.h"
#import "UserElection+API.h"

@interface NearbyPollingViewController : VIPViewController <ContactsSearchViewControllerDelegate,
                                                            GMSMapViewDelegate,
                                                            UITableViewDelegate,
                                                            UITableViewDataSource,
                                                            UIActionSheetDelegate,
                                                            DirectionsListViewControllerDelegate>

@property (strong, nonatomic) UserElection *election;

/** List of PollingLocationWrapper objects representing currently viewed locations */
@property (strong, nonatomic) NSMutableArray *cells;

/** Handler for when the view switcher button is pressed (upper right)
 */
- (IBAction)onViewSwitcherClicked:(id)sender;

@end
