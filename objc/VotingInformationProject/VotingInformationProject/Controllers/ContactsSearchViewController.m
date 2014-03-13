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

@interface ContactsSearchViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *showPeoplePicker;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UIButton *showElectionButton;
@property (strong, nonatomic) UserAddress *userAddress;
@property (strong, nonatomic) NSArray *elections;
@property (strong, nonatomic) Election *currentElection;

@end

@implementation ContactsSearchViewController {
    NSManagedObjectContext *_moc;
}

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
    [self.showElectionButton setTitle:NSLocalizedString(@"Updating...", nil)
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
        NSError *error = [VIPError errorWithCode:VIPError.VIPNoValidElections];
        [self displayGetElectionsError:error];
        return;
    }

    _elections = elections;

    // if ElectionID set in settings.plist set and is a valid election, set as current
    NSString *settingsPath = [[NSBundle mainBundle] pathForResource:@"settings" ofType:@"plist"];
    NSDictionary *appSettings = [[NSDictionary alloc] initWithContentsOfFile:settingsPath];
    NSString *electionId = [appSettings valueForKey:@"ElectionID"];
    for (Election *e in _elections) {
        if ([e.electionId isEqualToString:electionId]) {
            _currentElection = e;
            break;
        }
    }
    // If no election got set above, default to first election in list
    if (!_currentElection) {
        _currentElection = _elections[0];
    }

    // Make request for _currentElection data
    [_currentElection
     getVoterInfo:^(BOOL success, NSError *error)
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
    _moc = [NSManagedObjectContext MR_contextForCurrentThread];

    /* i18n Sample Demo
     Use number formatter/date formatter/etc for numbers, dates, etc. Controlled by:
        Settings.app->General->International->Region Format
     Control language settings via:
        Settings.app->General->International->Language
     
    Second argument to NSLocalizedString is a comment to be provided in the Localizable.strings file
        for translator context
    
    genstrings is an xcode command line tool for generating a Localizable.strings file from
     all NSLocalizedString calls in your app.
     https://developer.apple.com/library/mac/documentation/Darwin/Reference/ManPages/man1/genstrings.1.html
     http://blog.spritebandits.com/2012/01/25/ios-iphone-app-localization-genstrings-tips/
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];

    NSString *oneMillion = [numberFormatter stringFromNumber:@(1000000)];
    self.localizationLabel.text = [NSString stringWithFormat:NSLocalizedString(@"NUMBER: %@", nil), oneMillion];
    */

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
        [_moc MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
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
    [self.showElectionButton setTitle:NSLocalizedString(@"Show Upcoming Election", nil)
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
        ? error.localizedDescription : NSLocalizedString(@"Unknown error getting elections", nil);
    [self.showElectionButton setTitle:errorTitle forState:UIControlStateDisabled];
    [self.showElectionButton setHidden:NO];
}
@end
