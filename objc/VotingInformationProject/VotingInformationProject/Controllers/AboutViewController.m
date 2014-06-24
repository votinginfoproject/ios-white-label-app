//
//  AboutViewController.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/19/14.
//

#import "AboutViewController.h"
#import "ContactsSearchViewController.h"
#import "VIPTabBarController.h"
#import "AppSettings.h"
#import "VIPColor.h"

@interface AboutViewController ()

@property (strong, nonatomic) NSArray *text;
@property (weak, nonatomic) IBOutlet UILabel *termsLabel;
@property (weak, nonatomic) IBOutlet UILabel *privacyLabel;
@property (weak, nonatomic) IBOutlet UILabel *aboutLabel;

@end

@implementation AboutViewController

- (NSArray*)text
{
    if (!_text) {
        _text = @[
                  NSLocalizedString(@"AboutAppText", @"'About' section in 'About this app'"),
                  NSLocalizedString(@"TermsOfUseText", @"'Terms of use' section in 'About this app'"),
                  NSLocalizedString(@"PrivacyPolicyText", @"'Privacy policy' section in 'About this app'")];
    }
    return _text;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.screenName = @"About App Screen";

    self.aboutLabel.text = self.text[0];
    self.termsLabel.text = self.text[1];
    self.privacyLabel.text = self.text[2];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static CGFloat heightPadding = 20;
    NSString *str = self.text[indexPath.section];
    CGSize maximumSize = CGSizeMake(280, CGFLOAT_MAX);
    NSDictionary *strAttributes = @{ NSFontAttributeName : [UIFont systemFontOfSize:15] };
    CGRect strSize = [str boundingRectWithSize:maximumSize
                                       options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                    attributes:strAttributes
                                       context:nil];
    return 2 * heightPadding + ceilf(strSize.size.height);
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UIColor *textColor = [VIPColor primaryTextColor];
    [[((UITableViewHeaderFooterView*) view) textLabel] setTextColor: textColor];
    view.backgroundColor = [VIPColor color:textColor withAlpha:0.5];
}

#pragma mark - ContactsSearchViewControllerDelegate

/* 
 * NOTE:
 * This delegate function call and the HomeSegue if block in the prepareForSegue method below are in
 * all of the tab bar root view controllers for each tab stack. I couldn't come up with
 * a good way to DRY it out so that there was only one instance of the "Home" button for
 * all of the tab navigation controllers. Each of the root view controllers has a separate
 * instance of that home button as well as a modal "HomeSegue" defined.
 * If someone has a good solution to this, please share.
 *
 * Tried:
 *  - Subclassing navigation controller, but that requires a bunch of logic to only display
 *    the button contionally on the root view
 *  - Superclassing each of the tab root controllers, but this is also messy because we have a mix
 *    of UIViewControllers and UITableViewControllers
 *
 */
- (void)contactsSearchViewControllerDidClose:(ContactsSearchViewController *)controller
                               withElections:(NSArray *)elections
                             currentElection:(UserElection *)election
                                    andParty:(NSString *)party
{
    VIPTabBarController *vipTabBarController = (VIPTabBarController*)self.tabBarController;
    vipTabBarController.elections = elections;
    vipTabBarController.currentElection = election;
    vipTabBarController.currentParty = party;
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"HomeSegue"]) {
        ContactsSearchViewController *csvc = (ContactsSearchViewController*) segue.destinationViewController;
        csvc.delegate = self;
        VIPTabBarController *vipTabBarController = (VIPTabBarController*)self.tabBarController;
        csvc.currentElection = vipTabBarController.currentElection;
    }
}

@end
