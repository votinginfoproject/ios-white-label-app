//
//  BallotDetailsViewController.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 3/13/14.
//

#import "BallotDetailsViewController.h"
#import "VIPTabBarController.h"
#import "UIWebViewController.h"
#import "State+API.h"

#import "ContestUrlCell.h"

@interface BallotDetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *electionNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *electionDateLabel;

@property (strong, nonatomic) NSMutableArray *tableData;
@end

@implementation BallotDetailsViewController

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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    VIPTabBarController *vipTabBarController = (VIPTabBarController *)self.tabBarController;
    self.election = (Election*) vipTabBarController.currentElection;
    [self updateUI];
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

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return NSLocalizedString(@"Election Administration Body", nil);
        default:
            return @"";
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"BallotUrlCellSegue"]) {
        UIWebViewController *webView = (UIWebViewController*) segue.destinationViewController;
        ContestUrlCell *cell = (ContestUrlCell*)sender;
        webView.title = NSLocalizedString(@"Website", nil);
        webView.url = cell.url;
    }
}

@end
