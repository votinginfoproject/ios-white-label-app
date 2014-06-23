//
//  BallotViewController.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/7/14.
//

#import "BallotViewController.h"
#import "ContactsSearchViewController.h"
#import "ContestDetailsViewController.h"
#import "VIPEmptyTableViewDataSource.h"
#import "Election+API.h"
#import "Contest+API.h"
#import "VIPColor.h"
#import "VIPUserDefaultsKeys.h"

@interface BallotViewController ()
@property (strong, nonatomic) NSString *party;
@property (weak, nonatomic) IBOutlet UILabel *electionNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *electionDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *selectedPartyLabel;
@property (strong, nonatomic) VIPEmptyTableViewDataSource *emptyDataSource;
@end

@implementation BallotViewController {
    NSArray *_contests;
}

const NSUInteger VIP_BALLOT_TABLECELL_HEIGHT = 44;

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

    self.emptyDataSource = [[VIPEmptyTableViewDataSource alloc]
                            initWithEmptyMessage:NSLocalizedString(@"No Contests Available",
                                                                   @"Text displayed by the table view if there are no contests to display")];

    self.screenName = @"Ballot Screen";
    self.electionNameLabel.textColor = [VIPColor primaryTextColor];
    self.electionDateLabel.textColor = [VIPColor secondaryTextColor];
    self.selectedPartyLabel.textColor = [VIPColor secondaryTextColor];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.tabBarController) {
        self.tabBarController.title = NSLocalizedString(@"Ballot", @"Name for bottom-left tab (ballot)");
    }

    VIPTabBarController *vipTabBarController = (VIPTabBarController *)self.tabBarController;

    if (![vipTabBarController isVIPDataAvailable]) {
        [self presentContactsSearchViewController];
    } else {
        self.election = (Election*) vipTabBarController.currentElection;
        self.party = vipTabBarController.currentParty;
        [self.election getVoterInfoIfExpired:^(BOOL success, NSError *error) {
            [self updateUI];
        }];
    }
}

- (void)setParty:(NSString *)party
{
    _party = party;
    self.selectedPartyLabel.text = [party uppercaseString];
}

- (id<UITableViewDataSource>)configureDataSource
{
    return ([_contests count] > 0) ? self : self.emptyDataSource;
}

/**
 *  Update UI with new contests
 */
- (void) updateUI
{
    if (!self.election) {
        return;
    }

    self.electionNameLabel.text = self.election.electionName;
    self.electionDateLabel.text = [self.election getDateString];

    NSArray *contests = [self.election getSorted:@"contests"
                                      byProperty:@"ballotPlacement"
                                       ascending:YES];

    if ([self.party length] > 0) {
        NSString *predicateFormat = @"SELF.primaryParty = nil OR SELF.primaryParty CONTAINS[cd] %@";
        NSPredicate *partyFilterPredicate = [NSPredicate
                                             predicateWithFormat:predicateFormat, self.party];

        contests = [contests filteredArrayUsingPredicate:partyFilterPredicate];
    }
    _contests = contests;
    self.tableView.dataSource = [self configureDataSource];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
                             currentElection:(Election *)election
                                    andParty:(NSString *)party
{
    VIPTabBarController *vipTabBarController = (VIPTabBarController*)self.tabBarController;
    vipTabBarController.elections = elections;
    vipTabBarController.currentElection = election;
    vipTabBarController.currentParty = party;
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_contests count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ContestCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Contest *contest = _contests[indexPath.item];
    NSString *title = [contest.type isEqualToString:REFERENDUM_API_ID]
        ? contest.referendumTitle : contest.office;
    cell.textLabel.text = title;
    cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
    cell.detailTextLabel.text = contest.type;
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ([_contests count] > 0) ? VIP_BALLOT_TABLECELL_HEIGHT : VIP_EMPTY_TABLECELL_HEIGHT;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"HomeSegue"]) {
        ContactsSearchViewController *csvc = (ContactsSearchViewController*) segue.destinationViewController;
        csvc.delegate = self;
        VIPTabBarController *vipTabBarController = (VIPTabBarController*)self.tabBarController;
        csvc.currentElection = vipTabBarController.currentElection;
    } else if ([segue.identifier isEqualToString:@"ContestDetailsSegue"]) {
        ContestDetailsViewController *cdvc = (ContestDetailsViewController*) segue.destinationViewController;
        UITableViewCell *cell = (UITableViewCell*)sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        Contest *contest = (Contest*)_contests[indexPath.item];
        cdvc.contest = contest;
        cdvc.electionName = self.election.electionName;
    }
}

- (void)presentContactsSearchViewController
{
    UIStoryboard *storyboard = self.storyboard;
    ContactsSearchViewController *csvc = [storyboard instantiateViewControllerWithIdentifier:@"ContactsSearchViewController"];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:csvc];
    csvc.delegate = self;
    [self presentViewController:navigationController animated:NO completion:nil];
}

@end
