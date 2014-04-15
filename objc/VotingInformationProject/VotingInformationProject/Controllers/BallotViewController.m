//
//  BallotViewController.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/7/14.
//

#import "BallotViewController.h"
#import "ContestDetailsViewController.h"
#import "VIPEmptyTableViewDataSource.h"
#import "Election+API.h"
#import "Contest+API.h"
#import "VIPColor.h"

@interface BallotViewController ()
@property (strong, nonatomic) NSString *party;
@property (weak, nonatomic) IBOutlet UILabel *electionNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *electionDateLabel;
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
                            initWithEmptyMessage:NSLocalizedString(@"No Elections Available",
                                                                   @"Text displayed by the table view if there are no elections to display")];

    self.screenName = @"Ballot Screen";
    self.electionNameLabel.textColor = [VIPColor primaryTextColor];
    self.electionDateLabel.textColor = [VIPColor secondaryTextColor];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.tabBarController) {
        self.tabBarController.title = NSLocalizedString(@"Ballot", @"Name for bottom-left tab (ballot)");
    }

    VIPTabBarController *vipTabBarController = (VIPTabBarController *)self.tabBarController;
    self.election = (Election*) vipTabBarController.currentElection;
    self.party = vipTabBarController.currentParty;
    [self.election getVoterInfoIfExpired:^(BOOL success, NSError *error) {
        [self updateUI];
    }];
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
                                      byProperty:@"office"
                                       ascending:YES];
    for (Contest *contest in contests) {
        NSLog(@"Contest: %@", contest.special);
    }
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
    if ([segue.identifier isEqualToString:@"ContestDetailsSegue"]) {
        ContestDetailsViewController *cdvc = (ContestDetailsViewController*) segue.destinationViewController;
        UITableViewCell *cell = (UITableViewCell*)sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        cdvc.contest = _contests[indexPath.item];
        cdvc.electionName = self.election.electionName;
    }
}

@end
