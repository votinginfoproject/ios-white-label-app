//
//  FindElectionsViewController.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 1/20/14.
//  
//

#import "FindElectionsViewController.h"

#import "ContactsSearchViewController.h"
#import "VIPTabBarController.h"
#import "VIPEmptyTableViewDataSource.h"
#import "VIPColor.h"

@interface FindElectionsViewController ()

@property (strong, nonatomic) VIPEmptyTableViewDataSource *emptyDataSource;
@end

@implementation FindElectionsViewController {
    NSArray *_elections;
}

const NSUInteger VIP_OTHER_ELECTIONS_TABLECELL_HEIGHT = 44;
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.emptyDataSource = [[VIPEmptyTableViewDataSource alloc]
                            initWithEmptyMessage:NSLocalizedString(@"No Additional Upcoming Elections",
                                                                   @"Text to show if the table view has no elections to display.")];
    self.screenName = @"Other Elections Screen";
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (id<UITableViewDataSource>)configureDataSource
{
    return ([_elections count] > 0) ? self : self.emptyDataSource;
}

- (void) setOtherElections
{
    VIPTabBarController *parentTabBarController = (VIPTabBarController*) self.tabBarController;

    _elections = [self removeInvalidElectionsFrom:parentTabBarController.elections
                               andCurrentElection:parentTabBarController.currentElection];
    self.tableView.dataSource = [self configureDataSource];
    [self.tableView reloadData];
}

- (NSArray*)removeInvalidElectionsFrom:(NSArray*)elections
                    andCurrentElection:(Election*)election
{
    NSMutableArray *mutableElections = [elections mutableCopy];
    NSUInteger numElections = [elections count];
    if (numElections > 1) {
        [mutableElections removeObject:election];
        NSDate *now = [NSDate date];
        for (Election *election in elections) {
            NSComparisonResult result = [now compare:election.date];
            if (result == NSOrderedDescending) {
                [mutableElections removeObject:election];
            }
        }
        return mutableElections;
    } else {
        return @[];
    }
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.tabBarController) {
        self.tabBarController.title = NSLocalizedString(@"More Elections",
                                                        @"Label for bottom-right tab button to view more elections");
    }

    [self setOtherElections];
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
    return [_elections count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ElectionCell";
    FindElectionsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    Election *election = [_elections objectAtIndex:indexPath.row];

    cell.nameLabel.text = election.electionName;
    cell.dateStringLabel.text = [election getDateString];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!_elections.count) {
        return; // if no elections to select
    }

    Election * currentElection = [_elections objectAtIndex:indexPath.row];
    VIPTabBarController *vipTabBarController = (VIPTabBarController*)self.tabBarController;
    vipTabBarController.currentElection = currentElection;
    [self performSegueWithIdentifier:@"HomeSegue" sender:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ([_elections count] > 0) ? VIP_OTHER_ELECTIONS_TABLECELL_HEIGHT : VIP_EMPTY_TABLECELL_HEIGHT;
}


#pragma mark - Segues

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"HomeSegue"]) {
        UINavigationController *navController = (UINavigationController*) segue.destinationViewController;
        ContactsSearchViewController *csvc = (ContactsSearchViewController*) navController.viewControllers[0];
        csvc.delegate = self;
        VIPTabBarController *vipTabBarController = (VIPTabBarController*)self.tabBarController;
        csvc.currentElection = vipTabBarController.currentElection;
    }
}


#pragma mark - ContactsSearchViewControllerDelegate
- (void)contactsSearchViewControllerDidClose:(ContactsSearchViewController *)controller
                               withElections:(NSArray *)elections
                             currentElection:(Election *)election
                                    andParty:(NSString *)party
{
    VIPTabBarController *vipTabBarController = (VIPTabBarController*)self.tabBarController;
    vipTabBarController.elections = elections;
    vipTabBarController.currentElection = election;
    vipTabBarController.currentParty = party;
    vipTabBarController.selectedIndex = 0;
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
