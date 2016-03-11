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
#import "AboutViewController.h"
#import "UIWebViewController.h"
#import "VIPPickerViewController.h"
#import "VIPTabBarController.h"

#import "UserElection+API.h"
#import "Election+API.h"
#import "VIPAddress+API.h"

#import "AppSettings.h"
#import "CivicInfoAPI.h"
#import "VIPColor.h"
#import "VIPUserDefaultsKeys.h"

@interface ContactsSearchViewController () <
    UITextFieldDelegate,
    AboutViewControllerDelegate
>

@property (weak, nonatomic) IBOutlet UIButton *partyPickerButton;
@property (weak, nonatomic) IBOutlet UIButton *showElectionButton;
@property (weak, nonatomic) IBOutlet UIButton *showPeoplePicker;

@property (weak, nonatomic) IBOutlet UILabel *brandNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (weak, nonatomic) IBOutlet UILabel *gettingStartedLabel;
@property (weak, nonatomic) IBOutlet UILabel *vipLabel;

@property (weak, nonatomic) IBOutlet UIView *partyView;
@property (weak, nonatomic) IBOutlet UIView *errorView;
@property (weak, nonatomic) IBOutlet UIView *electionsView;

@property (weak, nonatomic) IBOutlet UITextField *addressTextField;

@property (weak, nonatomic) IBOutlet UIButton *electionPickerButton;

@property (strong, nonatomic) Election *activeElection;

@property (strong, nonatomic) NSString *userAddress;
@property (strong, nonatomic) NSString *currentParty;
@property (strong, nonatomic) NSString *allPartiesString;

@property (strong, nonatomic) NSArray *elections;
@property (strong, nonatomic) NSArray *parties;
@end

@implementation ContactsSearchViewController {
    BOOL _updating;
}

#pragma mark - setters
/**
 *  Setter for userAddress
 * 
 *  When we set the userAddress, we want to kick off a refresh of hte election/voterinfo
 *  data. This progress is indicated to the user
 *
 *  @param userAddress
 */
- (void)setUserAddress:(NSString *)userAddress
{
    if (userAddress == nil || [userAddress length] == 0) {
        return;
    }
  
    if ([userAddress isEqualToString:_userAddress]) {
        NSLog(@"No change. New address %@ == old", _userAddress);
        return;
    }
  
    _userAddress = userAddress;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:userAddress forKey:USER_DEFAULTS_STORED_ADDRESS];
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

- (void)setCurrentElection:(UserElection *)currentElection
{
    _currentElection = currentElection;
}

- (void)setElections:(NSArray *)elections
{
    self.electionsView.hidden = [elections count] < 2 ? YES : NO;
  
    if (self.activeElection) {
        [self.electionPickerButton setTitle:self.activeElection.name
                                   forState:UIControlStateNormal];
    } else if ([elections count] > 0) {
        [self.electionPickerButton setTitle:((Election*)elections[0]).name
                                   forState:UIControlStateNormal];
    }
  
    _elections = elections;
}

- (void)setActiveElection:(Election *)activeElection
{
    if ([activeElection.name length] > 0) {
        [self.electionPickerButton setTitle:activeElection.name
                                   forState:UIControlStateNormal];
    }
  
    _activeElection = activeElection;
}

#pragma mark - view lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.screenName = @"Home Screen";
    _updating = NO;

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

    self.currentParty = self.allPartiesString;
    self.parties = @[self.allPartiesString];
}

//Hide nav bar on root view
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
  
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *address = [defaults objectForKey:USER_DEFAULTS_STORED_ADDRESS];
  
    self.userAddress = address;
    self.addressTextField.text = address;
  
    if (!self.currentElection) {
        [self updateUI];
    } else {
        [self updateUICurrentElection];
    }

    [defaults setObject:nil forKey:USER_DEFAULTS_JSON];
    [defaults setObject:nil forKey:USER_DEFAULTS_PARTY];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *party = [self.currentParty isEqualToString:self.allPartiesString] ? nil : self.currentParty;
    [defaults setObject:[self.currentElection toJSONString] forKey:USER_DEFAULTS_JSON];
    [defaults setObject:self.userAddress forKey:USER_DEFAULTS_STORED_ADDRESS];
    [defaults setObject:party forKey:USER_DEFAULTS_PARTY];

    [super viewWillDisappear:animated];
}

/**
 * Update UI by requesting votingInfo data from API
 */
- (void) updateUI
{
    if (_updating) {
        return;
    }
  
    [self hideViews];
  
    if ([self.userAddress length] == 0) {
        return;
    }
  
    _updating = YES;
  
    NSLog(@"Requesting: %@", self.userAddress);
    [CivicInfoAPI getVotingInfo:self.userAddress forElection:self.activeElection callback:^(UserElection *votingInfo, NSError *error) {
      
        if (votingInfo && !error) {
            self.currentElection = votingInfo;
            [self updateUICurrentElection];
        } else {
            NSLog(@"ERROR getting election: %@", error);
            NSLog(@"ERROR: %@", votingInfo);
            [self displayGetElectionsError:error];
        }
      
        _updating = NO;
    }];
}

- (void)hideViews
{
    self.partyView.hidden = YES;
    self.errorView.hidden = YES;
    self.electionsView.hidden = YES;
    self.showElectionButton.hidden = YES;
}

- (void) dismissKeyboard {
    [self.view endEditing:YES];
}

/**
 *  Part of the update process, see updateUI for details
 */
- (void)updateUICurrentElection
{
    // Update self.elections, self.activeElections
    NSArray *elections = @[];
  
    if (self.currentElection) {
        if ([self.currentElection.otherElections count] > 0) {
            elections = self.currentElection.otherElections;
        }
      
        elections = [elections arrayByAddingObject:self.currentElection.election];
    }
  
    self.elections = elections;
    self.activeElection = self.currentElection.election;

    [self displayPartyPicker];
    [self displayGetElections];
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
        [peoplePicker dismissViewControllerAnimated:YES completion:nil];
        NSString *address = [self getAddress:person atIdentifier:identifier];
        self.userAddress = address;
        self.addressTextField.text = address;
        [self updateUI];
      
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

- (IBAction)tappedShowElectionButton:(id)sender
{
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
    if (![self.userAddress isEqualToString:textField.text]) {
        self.userAddress = textField.text;
        [self updateUI];
    }
}

// close the keyboard when user taps return
- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
  
    return NO;
}

#pragma mark - electionPicker

- (IBAction)showElectionPicker:(id)sender
{
    [self.addressTextField resignFirstResponder];
  
    if ([self.elections count] == 0) {
        return;
    }

    VIPPickerViewController *electionPickerViewController =
        [VIPPickerViewController  initWithData:self.elections
                                      selected:(NSInteger)[self.elections indexOfObject:self.currentElection]
                                     converter:^NSString *(Election *election) {
                                       return election.name;
                                     }
                                    completion:^(Election *election) {
                                      self.activeElection = election;
                                    }];

    [self presentViewController:electionPickerViewController animated:YES completion:nil];
}

#pragma mark - PartyPicker

- (IBAction)showPartyView:(id)sender
{
    [self.addressTextField resignFirstResponder];

    VIPPickerViewController *partyPickerViewController =
        [VIPPickerViewController  initWithData:self.parties
                                      selected:(NSInteger)[self.parties indexOfObject:self.currentParty]
                                     converter:nil
                                    completion:^(NSString* selectedParty) {
                                      self.currentParty = selectedParty;
                                      [self displayGetElections];
                                    }];
  
    [self presentViewController:partyPickerViewController animated:YES completion:nil];
}

- (void)displayPartyPicker
{
    NSArray *parties = [self.currentElection getUniqueParties];
    self.parties = [@[self.allPartiesString]
                    arrayByAddingObjectsFromArray:parties];
  
    BOOL showPartyPicker = [self.parties count] > 1 ? YES : NO;
    self.partyView.hidden = !showPartyPicker;
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

- (NSString*)allPartiesString
{
  if (!_allPartiesString) {
    _allPartiesString = NSLocalizedString(@"All Parties", @"Default selection for the party selection picker");
  }
  
  return _allPartiesString;
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
        ? error.localizedDescription
        : NSLocalizedString(@"Unknown error getting elections", @"Error message displayed in button on first screen when app cannot get election data");
    self.errorLabel.text = errorTitle;
}

#pragma mark - AboutViewControllerDelegate

-(void)aboutViewControllerDidClose:(AboutViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"AboutSegue"]) {
        UINavigationController *navigationViewController = (UINavigationController*)segue.destinationViewController;
        AboutViewController *viewController = navigationViewController.viewControllers[0];
        viewController.delegate = self;
    }
}

@end
