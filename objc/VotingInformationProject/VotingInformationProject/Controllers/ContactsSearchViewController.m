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

- (void)setUserAddress:(UserAddress *)userAddress
{
    if ([userAddress.address isEqualToString:_userAddress.address]) {
        return;
    }
    _userAddress = userAddress;
    // update elections when we set a new userAddress
    [Election
     getElectionsAt:_userAddress
     resultsBlock:^(NSArray *elections, NSError *error){
         if (error || [elections count] == 0) {
             [self displayGetElectionsError:error];
         } else {
             self.elections = elections;
         }
     }];
}

- (void)setElections:(NSArray *)elections
{
    if (elections && [elections count] > 0) {
        _elections = elections;
        _currentElection = _elections[0];
        [_currentElection
         getVoterInfo:^(AFHTTPRequestOperation *operation, NSDictionary *json)
         {
             [_currentElection parseVoterInfoJSON:json];
             self.showElectionButton.enabled = YES;
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             [self displayGetElectionsError:error];
         }];
    } else {
        _elections = @[];
        _currentElection = nil;
    }
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
    } else if ([segue.identifier isEqualToString:@"WebViewSegue"]) {
#pragma mark - UIWebViewController example
        NSString *urlString = @"http://hipsteripsum.me/?paras=4&type=hipster-centric";
        UIWebViewController *webViewController = segue.destinationViewController;
        // Set webView's navigation bar title
        webViewController.title = @"HipsterIpsum";
        // Set webView url to load
        webViewController.url = [NSURL URLWithString:urlString];
    }
}


#pragma mark - UITextField

- (void) textFieldDidEndEditing:(UITextField *)textField
{
    // TODO: If textField.text != userAddress.address
    //          create new userAddress and assign as current
    //          optionally check if elections exist and indicate to user
}

// close the keyboard when user taps return
- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}


#pragma mark - UI Error Handling
- (void) displayGetElectionsError:(NSError*)error
{
    // TODO: implement
    self.showElectionButton.enabled = NO;
}
@end
