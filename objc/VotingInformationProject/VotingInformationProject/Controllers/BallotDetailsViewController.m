//
//  BallotDetailsViewController.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 3/13/14.
//

#import "BallotDetailsViewController.h"
#import "VIPEmptyTableViewDataSource.h"
#import "VIPTabBarController.h"
#import "UIWebViewController.h"
#import "State+API.h"
#import "VIPColor.h"

#import "ContestUrlCell.h"

@interface BallotDetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *electionNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *electionDateLabel;

@property (strong, nonatomic) NSMutableArray *tableData;
@property (strong, nonatomic) VIPEmptyTableViewDataSource *emptyDataSource;
@end

@implementation BallotDetailsViewController

const NSUInteger VIP_DETAILS_TABLECELL_HEIGHT = 44;

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
    self.emptyDataSource = [[VIPEmptyTableViewDataSource alloc]
                            initWithEmptyMessage:NSLocalizedString(@"No Election Details Available",
                                                                   @"Text displayed by the table view if there are no election details to display")];
    self.electionNameLabel.textColor = [VIPColor primaryTextColor];
    self.electionDateLabel.textColor = [VIPColor secondaryTextColor];

    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    VIPTabBarController *vipTabBarController = (VIPTabBarController *)self.tabBarController;
    self.election = (Election*) vipTabBarController.currentElection;
    [self updateUI];
}

- (id<UITableViewDataSource>)configureDataSource
{
    return ([self.tableData[0] count] > 0) ? self : self.emptyDataSource;
}

- (void) updateUI
{
    if (!self.election) {
        return;
    }

    self.electionNameLabel.text = self.election.electionName;
    self.electionDateLabel.text = [self.election getDateString];

    [self.tableData removeAllObjects];
    NSArray *states = [self.election.states allObjects];
    //TODO: Allow for multiple state selection. In US the states set will only ever have 0-1 entries
    if ([states count] == 1) {
        State *state = (State*)states[0];
        NSMutableArray *eabProperties = [state.electionAdministrationBody getProperties];
        [self.tableData addObject:eabProperties];
        self.tableView.dataSource = [self configureDataSource];
        [self.tableView reloadData];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    if (dataUrl.scheme && [dataUrl.scheme length] > 0) {
        ContestUrlCell *cell = (ContestUrlCell*)[tableView dequeueReusableCellWithIdentifier:CONTEST_URL_CELLID
                                                                                forIndexPath:indexPath];
        [cell configure:property[@"title"] withUrl:property[@"data"]];
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ElectionDetailsCell"
                                                                forIndexPath:indexPath];
        cell.textLabel.text = property[@"title"];
        cell.detailTextLabel.text = property[@"data"];
        return cell;
    }
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ([self.tableData[0] count] > 0) ? VIP_DETAILS_TABLECELL_HEIGHT : VIP_EMPTY_TABLECELL_HEIGHT;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return NSLocalizedString(@"Election Administration Body",
                                     @"List header for election 'Details' tab");
        default:
            return @"";
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UIColor *textColor = [VIPColor primaryTextColor];
    view.backgroundColor = [VIPColor color:textColor withAlpha:0.5];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"BallotUrlCellSegue"]) {
        UIWebViewController *webView = (UIWebViewController*) segue.destinationViewController;
        ContestUrlCell *cell = (ContestUrlCell*)sender;
        webView.title = cell.descriptionLabel.text;
        webView.url = cell.url;
    }
}

@end
