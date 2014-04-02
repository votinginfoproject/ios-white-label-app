//
//  ContactsSearchViewController.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 1/22/14.
//  
//
// Great project that quickly seeds the iOS Simulator with Contacts:
//  https://github.com/cristianbica/CBSimulatorSeed

#import "ContactsSearchViewController.h"
#import "AppSettings.h"
#import "VIPColor.h"

@interface ContactsSearchViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *showPeoplePicker;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UIButton *showElectionButton;
@property (strong, nonatomic) UserAddress *userAddress;
@property (strong, nonatomic) NSArray *elections;
@property (strong, nonatomic) Election *currentElection;
@property (weak, nonatomic) IBOutlet UILabel *brandNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *vipLabel;
@property (weak, nonatomic) IBOutlet UILabel *gettingStartedLabel;
@property (weak, nonatomic) IBOutlet UIButton *aboutAppButton;

@end

@implementation ContactsSearchViewController

/**
 *  Setter for userAddress
 * 
 *  When we set the userAddress, we want to kick off a refresh of hte election/voterinfo
 *  data. This progress is indicated to the user
 *
 *  @param userAddress
 */
- (void)setUserAddress:(UserAddress *)userAddress
{
    if ([userAddress.address isEqualToString:_userAddress.address]) {
        NSLog(@"No change. New address %@ == old", _userAddress.address);
        return;
    }
    _userAddress = userAddress;

    // Indicate an update is happening...
    // TODO: Add delay so this only shows if requests are taking more than x seconds
    self.showElectionButton.enabled = NO;
    [self.showElectionButton setTitle:NSLocalizedString(@"Updating...", @"Message that displays while app loads election and voter info after user changes their address")
                             forState:UIControlStateDisabled];

    // update elections when we set a new userAddress
    [Election
     getElectionsAt:_userAddress
     resultsBlock:^(NSArray *elections, NSError *error){
         if (!error && [elections count] > 0) {
             self.elections = elections;
         } else {
             [self displayGetElectionsError:error];
         }
     }];
}

/**
 *  Setter for elections
 *
 *  When elections are set, we also want ot update the currentElection and update its data
 *  from the voterInfo query
 *
 *  @param elections
 */
- (void)setElections:(NSArray *)elections
{
    _currentElection = nil;
    // if elections is nil or no elections in NSArray, bail out
    if ([elections count] == 0) {
        _elections = @[];
        NSError *error = [VIPError errorWithCode:VIPError.NoValidElections];
        [self displayGetElectionsError:error];
        return;
    }

    _elections = elections;

    // if ElectionID set in settings.plist set and is a valid election, set as current
    NSString *electionId = [[AppSettings settings] valueForKey:@"ElectionID"];
    NSLog(@"Requesting election: %@", electionId);
    NSLog(@"Available elections:");
    for (Election *e in _elections) {
        NSLog(@"%@", e.electionId);
        if ([e.electionId isEqualToString:electionId]) {
            _currentElection = e;
            break;
        }
    }

    // If no election got set above, when specific election requested, error.
    if (electionId && !_currentElection) {
        [self displayGetElectionsError:[VIPError errorWithCode:[VIPError NoValidElections]]];
        return;
    } else if (!_currentElection) {
        _currentElection = elections[0];
    }

    // Make request for _currentElection data
    [_currentElection
     getVoterInfoIfExpired:^(BOOL success, NSError *error)
     {
         if (success) {
             [self displayGetElections];
         } else {
             [self displayGetElectionsError:error];
         }
     }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.screenName = @"Home Screen";

    self.vipLabel.textColor = [VIPColor primaryTextColor];
    self.brandNameLabel.textColor = [VIPColor secondaryTextColor];
    self.gettingStartedLabel.textColor = [VIPColor primaryTextColor];
    [self.aboutAppButton setTitleColor:[VIPColor primaryTextColor]
                              forState:UIControlStateNormal];
    [self.showElectionButton setTitleColor:[VIPColor primaryTextColor]
                                  forState:UIControlStateNormal];

    self.brandNameLabel.text = [[AppSettings UIStringForKey:@"BrandNameText"] uppercaseString];
    self.vipLabel.text = NSLocalizedString(@"Voting Information",
                                           @"Localized brand name for the Voting Information Project");
    self.gettingStartedLabel.text = NSLocalizedString(@"Get started by providing the address where you are registered to live.",
                                                      @"App home page instruction text for the address text field and contacts picker");
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - view appears

//Hide nav bar on root view
- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];

    UserAddress *userAddress = [UserAddress MR_findFirstOrderedByAttribute:@"lastUsed"
                                                                 ascending:NO];
    self.addressTextField.text = userAddress.address;
    self.userAddress = userAddress;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - contacts picker

- (IBAction)showPeoplePicker:(id)sender
{
    ABPeoplePickerNavigationController *picker =
    [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    // Only want to allow the user to select address entries
    picker.displayedProperties = @[[NSNumber numberWithInt:kABPersonAddressProperty]];

    [self presentViewController:picker animated:YES completion:nil];
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    // return YES shows contact details view with list of contact properties
    return YES;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier
{
    if (property == kABPersonAddressProperty) {
        NSString *address = [self getAddress:person atIdentifier:identifier];
        UserAddress *selectedAddress = [UserAddress getUnique:address];
        NSManagedObjectContext *moc = [NSManagedObjectContext MR_defaultContext];
        [moc MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
            NSLog(@"DataStore saved: %d", success);
        }];
        self.userAddress = selectedAddress;

        [peoplePicker dismissViewControllerAnimated:YES completion:nil];
        return NO;
    }

    return YES;
}

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
}

- (NSString *) getAddress: (ABRecordRef) person
          atIdentifier: (ABMultiValueIdentifier) identifier
{
    ABMultiValueRef addresses = ABRecordCopyValue(person, kABPersonAddressProperty);
    NSArray *addressesArray = (__bridge_transfer NSArray *) ABMultiValueCopyArrayOfAllValues(addresses);
    const NSUInteger addressIndex = ABMultiValueGetIndexForIdentifier(addresses, identifier);
    NSDictionary *addressDict = [addressesArray objectAtIndex:addressIndex];
    NSString *address = ABCreateStringWithAddressDictionary(addressDict, NO);
    CFRelease(addresses);
    return address;
}


#pragma mark - Segues

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"BallotView"]) {
        VIPTabBarController *vipTabBarController = segue.destinationViewController;
        vipTabBarController.elections = self.elections;
        vipTabBarController.currentElection = self.currentElection;
    }
}


#pragma mark - UITextField

- (void) textFieldDidEndEditing:(UITextField *)textField
{
    if (![self.userAddress.address isEqualToString:textField.text]) {
        self.userAddress = [UserAddress getUnique:textField.text];
    }
}

// close the keyboard when user taps return
- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}


#pragma mark - UI Error Handling

/**
 *  Enable button and display relevant text
 */
- (void)displayGetElections
{
    self.showElectionButton.enabled = YES;
    [self.showElectionButton setTitle:NSLocalizedString(@"Show Upcoming Election", @"Text for button on first screen to show upcoming election for user's address")
                             forState:UIControlStateNormal];
    [self.showElectionButton setHidden:NO];
    [self performSegueWithIdentifier: @"BallotView" sender: self.showElectionButton];
}

/**
 *  Error handle getting elections by displaying error as the text of the button
 *  and setting state to disabled
 *
 *  @param error NSError to display, button text displayed from localizedDescription property
 */
- (void) displayGetElectionsError:(NSError*)error
{
    self.showElectionButton.enabled = NO;
    NSString *errorTitle = error.localizedDescription
        ? error.localizedDescription : NSLocalizedString(@"Unknown error getting elections", @"Error message displayed in button on first screen when app cannot get election data");
    [self.showElectionButton setTitle:errorTitle forState:UIControlStateDisabled];
    [self.showElectionButton setHidden:NO];
}
@end
