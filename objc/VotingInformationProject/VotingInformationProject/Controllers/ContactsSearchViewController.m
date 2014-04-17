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

#import "MMPickerView.h"

#import "AppSettings.h"
#import "VIPColor.h"

@interface ContactsSearchViewController () <UITextFieldDelegate>

@property (strong, nonatomic) UserAddress *userAddress;
@property (strong, nonatomic) Election *currentElection;
@property (strong, nonatomic) NSString *currentParty;
@property (strong, nonatomic) NSArray *elections;
@property (strong, nonatomic) NSArray *parties;
@property (weak, nonatomic) IBOutlet UIButton *aboutAppButton;
@property (weak, nonatomic) IBOutlet UIButton *partyPickerButton;
@property (weak, nonatomic) IBOutlet UIButton *showElectionButton;
@property (weak, nonatomic) IBOutlet UIButton *showPeoplePicker;
@property (weak, nonatomic) IBOutlet UILabel *brandNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (weak, nonatomic) IBOutlet UILabel *gettingStartedLabel;
@property (weak, nonatomic) IBOutlet UILabel *vipLabel;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UIView *partyView;
@property (weak, nonatomic) IBOutlet UIView *errorView;

@end

@implementation ContactsSearchViewController {
    NSString *_allPartiesString;
    BOOL _hasShownPartyPicker;
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
    if (userAddress == nil || [userAddress.address length] == 0) {
        return;
    }
    if ([userAddress.address isEqualToString:_userAddress.address]) {
        NSLog(@"No change. New address %@ == old", _userAddress.address);
        return;
    }
    _userAddress = userAddress;

    self.partyView.hidden = YES;
    self.errorView.hidden = YES;
    self.showElectionButton.hidden = YES;

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
             NSArray *parties = [self.currentElection getUniqueParties];
             self.parties = [@[_allPartiesString]
                             arrayByAddingObjectsFromArray:parties];
             BOOL showPartyPicker = [self.parties count] > 1 ? YES : NO;
             if (showPartyPicker) {
                 [self displayPartyPicker];
             } else {
                 [self displayGetElections];
             }
         } else {
             [self displayGetElectionsError:error];
         }
     }];
}

- (void)setCurrentParty:(NSString *)currentParty
{
    [self.partyPickerButton setTitle:currentParty
                            forState:UIControlStateNormal];
    _currentParty = currentParty;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.screenName = @"Home Screen";

    UIColor *primaryTextColor = [VIPColor primaryTextColor];
    UIColor *primaryTextColorWithAlpha25 = [VIPColor color:primaryTextColor
                                                 withAlpha:0.25];
    UIColor *secondaryTextColor = [VIPColor secondaryTextColor];

    self.addressTextField.textColor = primaryTextColor;
    self.addressTextField.backgroundColor = [VIPColor color:primaryTextColor withAlpha:0.35];
    self.addressTextField.borderStyle = UITextBorderStyleRoundedRect;

    [self.aboutAppButton setTitleColor:primaryTextColor
                              forState:UIControlStateNormal];

    [self.showElectionButton setTitleColor:primaryTextColor
                                  forState:UIControlStateNormal];
    self.showElectionButton.layer.cornerRadius = 5;
    self.showElectionButton.backgroundColor = secondaryTextColor;

    self.brandNameLabel.textColor = secondaryTextColor;
    self.brandNameLabel.text = [[AppSettings UIStringForKey:@"BrandNameText"] uppercaseString];

    self.vipLabel.text = NSLocalizedString(@"Voting Information",
                                           @"Localized brand name for the Voting Information Project");

    self.gettingStartedLabel.text = NSLocalizedString(@"Get started by providing the address where you are registered to live.",
                                                      @"App home page instruction text for the address text field and contacts picker");

    self.partyPickerButton.backgroundColor = primaryTextColorWithAlpha25;
    self.partyPickerButton.layer.cornerRadius = 5;

    _hasShownPartyPicker = NO;
    _allPartiesString = NSLocalizedString(@"All Parties", @"Default selection for the party selection picker");
    self.currentParty = _allPartiesString;
    self.parties = @[_allPartiesString];
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

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self shiftElectionButton];
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
        NSString *party = [self.currentParty isEqualToString:_allPartiesString] ? nil : self.currentParty;
        vipTabBarController.currentParty = party;
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

- (IBAction)showPartyView:(id)sender {
    [MMPickerView showPickerViewInView:self.view
                           withStrings:self.parties
                           withOptions:@{MMselectedObject: self.currentParty}
                            completion:^(NSString* selectedString) {
                                self.currentParty = selectedString;
                                [self displayGetElections];
    }];
}

- (void)displayPartyPicker
{
    self.partyView.hidden = NO;
    if (_hasShownPartyPicker) {
        [self displayGetElections];
    }
    if (!_hasShownPartyPicker) {
        _hasShownPartyPicker = YES;
    }
}

- (void)shiftElectionButton
{
    BOOL shouldShiftButton = !([self.parties count] > 1);
    CGRect partyViewFrame = self.partyView.frame;
    CGRect showElectionButtonFrame = self.showElectionButton.frame;
    CGFloat buttonPadding = 10;
    if (shouldShiftButton) {
        showElectionButtonFrame.origin.y = partyViewFrame.origin.y;
    } else {
        showElectionButtonFrame.origin.y = partyViewFrame.origin.y + buttonPadding + partyViewFrame.size.height;
    }
    self.showElectionButton.frame = showElectionButtonFrame;
}

/**
 *  Enable button and display relevant text
 */
- (void)displayGetElections
{
    self.errorView.hidden = YES;
    self.showElectionButton.hidden = NO;
    [self.showElectionButton setTitle:NSLocalizedString(@"GO!", @"Home view GO! button text")
                             forState:UIControlStateNormal];
}

/**
 *  Error handle getting elections by displaying error as the text of the button
 *  and setting state to disabled
 *
 *  @param error NSError to display, button text displayed from localizedDescription property
 */
- (void) displayGetElectionsError:(NSError*)error
{
    self.showElectionButton.hidden = YES;
    self.partyView.hidden = YES;
    self.errorView.hidden = NO;
    NSString *errorTitle = error.localizedDescription
        ? error.localizedDescription : NSLocalizedString(@"Unknown error getting elections", @"Error message displayed in button on first screen when app cannot get election data");
    self.errorLabel.text = errorTitle;
}
@end
