//
//  ContactsSearchViewController.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 1/22/14.
//  
//
// Great project that quickly seeds the iOS Simulator with Contacts:
//  https://github.com/cristianbica/CBSimulatorSeed

#import "UIWebViewController.h"
#import "VIPTabBarController.h"
#import "ContactsSearchViewController.h"

#import "MMPickerView.h"

#import "AppSettings.h"
#import "UserElection+API.h"
#import "Election+API.h"
#import "UserAddress+API.h"
#import "VIPColor.h"
#import "VIPUserDefaultsKeys.h"

@interface ContactsSearchViewController () <UITextFieldDelegate>

@property (strong, nonatomic) Election *activeElection;
@property (strong, nonatomic) UserAddress *userAddress;
@property (strong, nonatomic) NSString *currentParty;
@property (strong, nonatomic) NSArray *elections;
@property (strong, nonatomic) NSArray *parties;
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
@property (weak, nonatomic) IBOutlet UIButton *electionPickerButton;
@property (strong, nonatomic) NSString* allPartiesString;

@end

@implementation ContactsSearchViewController {
    BOOL _hasShownPartyPicker;
}

- (NSString*)allPartiesString
{
    if (!_allPartiesString) {
        _allPartiesString = NSLocalizedString(@"All Parties", @"Default selection for the party selection picker");
    }
    return _allPartiesString;
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
    self.currentElection = [UserElection getUnique:self.activeElection.electionId
                                   withUserAddress:userAddress];
}

/**
 *  Setter for currentParty, update partyPicker button choices when updated
 *
 *  @param currentParty NSString*
 */
- (void)setCurrentParty:(NSString *)currentParty
{
    [self.partyPickerButton setTitle:currentParty
                            forState:UIControlStateNormal];
    _currentParty = currentParty;
}

- (void)setElections:(NSArray *)elections
{
    if (!elections) {
        [self.electionPickerButton setTitle:NSLocalizedString(@"No Elections Available", nil)
                                   forState:UIControlStateNormal];
    } else if (!self.currentElection) {
        [self.electionPickerButton setTitle:NSLocalizedString(@"Choose an Election", nil)
                                   forState:UIControlStateNormal];
    } else {
        [self.electionPickerButton setTitle:self.activeElection.electionName
                                   forState:UIControlStateNormal];
    }
    _elections = elections;
}

- (void)setActiveElection:(Election *)activeElection
{
    if ([activeElection.electionName length] > 0) {
        [self.electionPickerButton setTitle:activeElection.electionName
                                   forState:UIControlStateNormal];
    }
    _activeElection = activeElection;
    self.currentElection = [UserElection getUnique:activeElection.electionId
                                   withUserAddress:self.userAddress];
}

- (void)setCurrentElection:(UserElection *)currentElection
{
    _currentElection = currentElection;
    [self updateUICurrentElection];
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

    [self.showElectionButton setTitleColor:primaryTextColor
                                  forState:UIControlStateNormal];
    self.showElectionButton.layer.cornerRadius = 5;
    self.showElectionButton.backgroundColor = secondaryTextColor;

    self.brandNameLabel.textColor = secondaryTextColor;
    self.brandNameLabel.text = [[AppSettings UIStringForKey:@"BrandNameText"] uppercaseString];

    self.vipLabel.text = NSLocalizedString(@"Voting Information",
                                           @"Localized brand name for the Voting Information Project");

    self.gettingStartedLabel.text = NSLocalizedString(@"Get started by providing the address where you are registered to vote.",
                                                      @"App home page instruction text for the address text field and contacts picker");

    self.electionPickerButton.backgroundColor = primaryTextColorWithAlpha25;
    [self.electionPickerButton setTitleColor:[VIPColor secondaryTextColor]
                                 forState:UIControlStateNormal];
    self.electionPickerButton.layer.cornerRadius = 5;

    self.partyPickerButton.backgroundColor = primaryTextColorWithAlpha25;
    [self.partyPickerButton setTitleColor:[VIPColor secondaryTextColor]
                                 forState:UIControlStateNormal];
    self.partyPickerButton.layer.cornerRadius = 5;

    _hasShownPartyPicker = NO;
    self.currentParty = self.allPartiesString;
    self.parties = @[self.allPartiesString];
}


#pragma mark - view appears

//Hide nav bar on root view
- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    UserAddress *userAddress = [UserAddress MR_findFirstOrderedByAttribute:@"lastUsed"
                                                                 ascending:NO];
    self.addressTextField.text = userAddress.address;
    self.userAddress = userAddress;

    NSString *activeElectionId = [defaults objectForKey:USER_DEFAULTS_ELECTION_ID];
    self.activeElection = [Election getUnique:activeElectionId];
    [self updateUI];

    [defaults setObject:nil forKey:USER_DEFAULTS_ELECTION_ID];
    [defaults setObject:nil forKey:USER_DEFAULTS_STORED_ADDRESS];
    [defaults setObject:nil forKey:USER_DEFAULTS_PARTY];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *party = [self.currentParty isEqualToString:self.allPartiesString] ? nil : self.currentParty;
    [defaults setObject:self.activeElection.electionId forKey:USER_DEFAULTS_ELECTION_ID];
    [defaults setObject:self.userAddress.address forKey:USER_DEFAULTS_STORED_ADDRESS];
    [defaults setObject:party forKey:USER_DEFAULTS_PARTY];

    [super viewWillDisappear:animated];
}

- (void)updateElections
{
    self.elections = [Election getFutureElections];
    [self.electionPickerButton setTitle:NSLocalizedString(@"Loading elections...",
                                                          @"Text for election picker button while elections are loading")
                               forState:UIControlStateNormal];
    [Election getElectionList:^(NSArray *elections, NSError *error) {
        self.elections = elections;
        if (error) {
            NSLog(@"Error getting election list: %@", error);
            NSError *error = [VIPError errorWithCode:VIPError.NoValidElections];
            [self displayGetElectionsError:error];
        }
    }];
}

/**
 *  Start the updateUI process
 *
 *  There are a few things that need to be updated for the election process.
 *  First, get elections for the userAddress the user just entered
 *  Then, ensure the currentElection is in the elections and update it
 *  or automatically choose the current election to be the next future election
 *
 *  Calls updateUIElections then updateUICurrentElection
 *  Can bail out of the update process at any time with [self displayGetElectionsError:error]
 */
- (void) updateUI
{
    [self hideViews];
    [self updateElections];
}

- (void)hideViews
{
    self.partyView.hidden = YES;
    self.errorView.hidden = YES;
    self.showElectionButton.hidden = YES;
}

/**
 *  Part of the update process, see updateUI for details
 */
- (void)updateUICurrentElection
{
    [self hideViews];
    // Make request for _currentElection data
    [self.currentElection
     getVoterInfoIfExpired:^(BOOL success, NSError *error)
     {
         if (success) {
             NSArray *parties = [self.currentElection getUniqueParties];
             self.parties = [@[self.allPartiesString]
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


#pragma mark - showElectionButton

- (IBAction)tappedShowElectionButton:(id)sender {
    // Set the current selections to local store so we can pull them from CoreData
    //  on future app loads

    NSString *party = [self.currentParty isEqualToString:self.allPartiesString] ? nil : self.currentParty;
    [self.delegate contactsSearchViewControllerDidClose:self
                                          withElections:self.elections
                                        currentElection:self.currentElection
                                               andParty:party];
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

#pragma mark - electionPicker

- (IBAction)showElectionPicker:(id)sender {
    [self.addressTextField resignFirstResponder];
    Election *selectedElection = [Election getUnique:self.currentElection.electionId];
    if (!selectedElection) {
        selectedElection = self.elections[0];
    }
    [MMPickerView showPickerViewInView:self.view
                           withObjects:self.elections
                           withOptions:@{MMselectedObject: selectedElection}
               objectToStringConverter:^NSString *(Election *election) {
                   return election.electionName;
               }
                            completion:^(Election *selectedElection) {
                                self.activeElection = selectedElection;
                                self.currentElection = [UserElection getUnique:self.activeElection.electionId
                                                               withUserAddress:self.userAddress];
                                [self updateUICurrentElection];
                            }];

}


#pragma mark - PartyPicker

- (IBAction)showPartyView:(id)sender {
    [self.addressTextField resignFirstResponder];
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

#pragma mark - UI Error Handling

/**
 *  Error handle getting elections by displaying error as the text of the button
 *  and setting state to disabled
 *
 *  @param error NSError to display, button text displayed from localizedDescription property
 */
- (void) displayGetElectionsError:(NSError*)error
{
    NSLog(@"displayGetElectionsError: %@", error);
    self.showElectionButton.hidden = YES;
    self.partyView.hidden = YES;
    self.errorView.hidden = NO;
    NSString *errorTitle = error.localizedDescription
        ? error.localizedDescription : NSLocalizedString(@"Unknown error getting elections", @"Error message displayed in button on first screen when app cannot get election data");
    self.errorLabel.text = errorTitle;
}
@end
