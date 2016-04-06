//
//  BallotDetailsViewController.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 3/13/14.
//

#import "BallotDetailsViewController.h"
#import "VIPEmptyTableViewDataSource.h"
#import "VIPTabBarController.h"
#import "ContactsSearchViewController.h"
#import "UIWebViewController.h"
#import "Election+API.h"
#import "State.h"
#import "VIPColor.h"
#import "VIPFeedbackView.h"

#import "ContestUrlCell.h"

@interface BallotDetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *electionNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *electionDateLabel;

@property (strong, nonatomic) NSMutableArray *tableData;
@property (strong, nonatomic) VIPEmptyTableViewDataSource *emptyDataSource;
@end

@implementation BallotDetailsViewController

const NSUInteger VIP_TABLE_HEADER_HEIGHT = 32;
const NSUInteger VIP_TABLE_FOOTER_HEIGHT = 19;
const NSUInteger VIP_DETAILS_TABLECELL_HEIGHT = 44;
const NSUInteger BDVC_TABLE_SECTION_STATE = 0;
const NSUInteger BDVC_TABLE_SECTION_LOCAL = 1;

- (NSMutableArray*)tableData
{
    if (!_tableData) {
        _tableData = [[NSMutableArray alloc] initWithCapacity:1];
    }
    return _tableData;
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

    self.screenName = @"Ballot Details Screen";
    self.electionNameLabel.textColor = [VIPColor primaryTextColor];
    self.electionDateLabel.textColor = [VIPColor secondaryTextColor];

    self.tableView.tableFooterView = [VIPFeedbackView inView:self.tableView
                                                withDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    VIPTabBarController *vipTabBarController = (VIPTabBarController *)self.tabBarController;
    self.election = (UserElection*) vipTabBarController.currentElection;
    [self updateUI];
}

- (void) updateUI
{
    if (!self.election) {
        return;
    }

    self.electionNameLabel.text = self.election.election.name;
    self.electionDateLabel.text = [self.election.election getDateString];

    [self.tableData removeAllObjects];
    NSArray *states = self.election.state;
    //TODO: Allow for multiple state selection. In US the states set will only ever have 0-1 entries
    if ([states count] == 1) {
        State *state = (State*)states[0];
        NSMutableArray *eabProperties = [state.electionAdministrationBody getProperties];
        if (!eabProperties) {
            NSString *noDataAvailable = NSLocalizedString(@"No Election Details Available",
                                                          @"Text displayed by the table view if there are no election details to display");
            eabProperties = [NSMutableArray arrayWithObject:@{@"data":@"", @"title":noDataAvailable}];
        }
        [self.tableData addObject:eabProperties];
        if (state.localJurisdiction) {
            NSMutableArray *localJurisdictionProperties =
            [state.localJurisdiction.electionAdministrationBody getProperties];
            if (localJurisdictionProperties) {
                [self.tableData addObject:localJurisdictionProperties];
            }
        }
        self.tableView.dataSource = self;
        [self.tableView reloadData];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - VIPFeedbackViewDelegate

- (void)sendFeedback:(VIPFeedbackView *)view
{
    NSMutableURLRequest *request = [self.election getFeedbackRequest];
    [self performSegueWithIdentifier:VIP_FEEDBACK_SEGUE sender:request];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.tableData count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableData[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = [indexPath section];
    NSDictionary *property = (NSDictionary *)self.tableData[section][indexPath.item];
    // Check if we can make a url from the data property
    NSURL *dataUrl = nil;
    if ([property isKindOfClass:[NSDictionary class]]) {
        dataUrl = [NSURL URLWithString:property[@"data"]];
    }

    // If we have a url, make this cell segue to UIWebViewController
    if ([dataUrl.scheme isEqualToString:@"http"] ||
        [dataUrl.scheme isEqualToString:@"https"]) {
        ContestUrlCell *cell = (ContestUrlCell*)[tableView dequeueReusableCellWithIdentifier:CONTEST_URL_CELLID
                                                                                forIndexPath:indexPath];
        [cell configure:property[@"title"] withUrl:property[@"data"]];
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ElectionDetailsCell"
                                                                forIndexPath:indexPath];
        [self configureDetailsCell:cell withDictionary:property];
        return cell;
    }
}

- (void)configureDetailsCell:(UITableViewCell*)cell
                withDictionary:(NSDictionary*)property
{
    UIColor *primaryTextColor = [VIPColor primaryTextColor];
    cell.textLabel.text = property[@"title"];
    cell.textLabel.textColor = primaryTextColor;
    cell.detailTextLabel.text = property[@"data"];
    cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:17];
    cell.detailTextLabel.textColor = primaryTextColor;
    cell.userInteractionEnabled = NO;
}

- (NSString*) titleForHeaderInSection:(NSInteger)section
{
    if (section == BDVC_TABLE_SECTION_STATE) {
        return NSLocalizedString(@"State", @"Section title for State Election Administration details");
    } else if (section == BDVC_TABLE_SECTION_LOCAL) {
        return NSLocalizedString(@"Local Jurisdiction", @"Section title for Local Election Administration details");
    }
    return @"";
}


#pragma mark - Table view delegate

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIColor *primaryTextColor = [VIPColor primaryTextColor];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, VIP_TABLE_HEADER_HEIGHT)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, tableView.frame.size.width, VIP_TABLE_HEADER_HEIGHT)];
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = primaryTextColor;
    label.text = [self titleForHeaderInSection:section];
    [view addSubview:label];
    [view setBackgroundColor:[VIPColor tableHeaderColor]];
    return view;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    NSInteger sections = [self.tableData count];
    NSInteger lastSectionCount = [self.tableData[sections - 1] count];
    BOOL footerHasHeight = section < sections - 1
                            && lastSectionCount != 0
                            && [self.tableData[0] count] > 0;
    return footerHasHeight ? VIP_TABLE_FOOTER_HEIGHT : 0;

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return VIP_TABLE_HEADER_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ([self.tableData[0] count] > 0) ? VIP_DETAILS_TABLECELL_HEIGHT : VIP_EMPTY_TABLECELL_HEIGHT;
}


#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"BallotUrlCellSegue"]) {
        UIWebViewController *webView = (UIWebViewController*) segue.destinationViewController;
        ContestUrlCell *cell = (ContestUrlCell*)sender;
        webView.title = cell.textLabel.text;
        webView.url = cell.url;
    } else if ([segue.identifier isEqualToString:@"HomeSegue"]) {
        ContactsSearchViewController *csvc = (ContactsSearchViewController*) segue.destinationViewController;
        csvc.delegate = self;
        VIPTabBarController *vipTabBarController = (VIPTabBarController*)self.tabBarController;
        csvc.currentElection = vipTabBarController.currentElection;
    } else if ([segue.identifier isEqualToString:VIP_FEEDBACK_SEGUE]) {
        UIWebViewController *webView = (UIWebViewController*) segue.destinationViewController;
        webView.title = NSLocalizedString(@"Feedback", @"Title for web view displaying the VIP election feedback form");
        webView.request = (NSMutableURLRequest*)sender;
    }
}


#pragma mark - ContactsSearchViewControllerDelegate

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

@end
