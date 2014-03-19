//
//  BallotViewController.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/7/14.
//

#import "BallotViewController.h"
#import "ContestDetailsViewController.h"
#import "Election+API.h"
#import "Contest+API.h"

@interface BallotViewController ()
@property (weak, nonatomic) IBOutlet UILabel *electionNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *electionDateLabel;
@end

@implementation BallotViewController {
    NSArray *_contests;
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
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.tabBarController) {
        self.tabBarController.title = NSLocalizedString(@"Ballot", "Name for bottom-left tab (ballot)");
    }

    VIPTabBarController *vipTabBarController = (VIPTabBarController *)self.tabBarController;
    self.election = (Election*) vipTabBarController.currentElection;
    [self.election getVoterInfoIfExpired:^(BOOL success, NSError *error) {
        // TODO: Error handle empty table here
        [self updateUI];
    }];
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

    _contests = [self.election getSorted:@"contests"
                              byProperty:@"office"
                               ascending:YES];
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
