//
//  ContestDetailsViewController.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/13/14.
//

#import "ContestDetailsViewController.h"

#import "CandidateDetailsViewController.h"
#import "UIWebViewController.h"
#import "ContestUrlCell.h"


@interface ContestDetailsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *contestNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *electionNameLabel;

// tableData is a 2d array where:
//  first dimension is # of sections
//  second dimension is data for each section
@property (strong, nonatomic) NSMutableArray *tableData;

@end

@implementation ContestDetailsViewController

NSString * const CDVC_TABLE_CELLID_PROPERTIES = @"ContestPropertiesCell";
NSUInteger const CDVC_TABLE_SECTION_PROPERTIES = 0;
NSString * const CDVC_TABLE_CELLID_CANDIDATES = @"CandidateCell";
NSUInteger const CDVC_TABLE_SECTION_CANDIDATES = 1;
NSString * const REFERENDUM_API_ID = @"Referendum";

- (NSMutableArray*)tableData
{
    if (!_tableData) {
        _tableData = [[NSMutableArray alloc] initWithCapacity:2];
    }
    return _tableData;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    [self updateUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

/**
 * Refresh data displayed in the elements on this view
 * Conditionally display Referendum elements if self.contest.type == REFERENDUM_API_ID
 */
- (void)updateUI
{
    if (!self.contest) {
        // TODO: Error handle this case?
        return;
    }
    [self.tableData removeAllObjects];
    self.electionNameLabel.text = self.electionName ?: NSLocalizedString(@"Not Available", nil);
    [self.tableData addObject:[self.contest getContestProperties]];

    if ([self.contest.type isEqualToString:REFERENDUM_API_ID]) {
        self.contestNameLabel.text = self.contest.referendumTitle;
        self.title = NSLocalizedString(@"Referendum", nil);
    } else {
        self.contestNameLabel.text = self.contest.office ?: NSLocalizedString(@"Not Available", nil);
        // Only add candidates for elections, not referenda
        [self.tableData addObject:[self.contest getSorted:@"candidates"
                                               byProperty:@"name"
                                                ascending:YES]];
    }
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
    if (section == CDVC_TABLE_SECTION_PROPERTIES && dataUrl.scheme && [dataUrl.scheme length] > 0) {
        ContestUrlCell *cell = (ContestUrlCell*)[tableView dequeueReusableCellWithIdentifier:CONTEST_URL_CELLID forIndexPath:indexPath];
        [self configureUrlTableViewCell:cell withDictionary:property];
        return cell;
    } else if (section == CDVC_TABLE_SECTION_PROPERTIES) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CDVC_TABLE_CELLID_PROPERTIES forIndexPath:indexPath];
        [self configurePropertiesTableViewCell:cell withDictionary:property];
        return cell;
    } else if (section == CDVC_TABLE_SECTION_CANDIDATES) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CDVC_TABLE_CELLID_CANDIDATES forIndexPath:indexPath];
        Candidate *candidate = (Candidate *)self.tableData[section][indexPath.item];
        [self configureCandidateTableViewCell:cell withCandidate:candidate];
        return cell;
    } else {
        return nil;
    }
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == CDVC_TABLE_SECTION_PROPERTIES && [self.contest.type isEqualToString:REFERENDUM_API_ID]) {
        return NSLocalizedString(@"Referendum Details", nil);
    } else if (section == CDVC_TABLE_SECTION_PROPERTIES) {
        return NSLocalizedString(@"Contest Details", nil);
    } else if (section == CDVC_TABLE_SECTION_CANDIDATES) {
        return NSLocalizedString(@"Candidates", nil);
    }
    return @"";
}

/**
 * @param section Table section returned by the table view
 * @return NSString* cell identifier for the passed section
 */
- (NSString*)cellIdentifierFor:(NSInteger) section
{
    if (section == CDVC_TABLE_SECTION_PROPERTIES) {
        return CDVC_TABLE_CELLID_PROPERTIES;
    } else if (section == CDVC_TABLE_SECTION_CANDIDATES) {
        return CDVC_TABLE_CELLID_CANDIDATES;
    }
    return nil;
}

/**
 * Configure one of the contest details cells
 *
 * TODO: Add appropriate styling -- do this in a subclass of UITableViewCell
 */
- (void)configurePropertiesTableViewCell:(UITableViewCell*)cell
                                       withDictionary:(NSDictionary*)property
{
    cell.textLabel.text = property[@"title"];
    cell.detailTextLabel.text = property[@"data"];
}

/**
 *  Configure a ContestUrlCell
 *
 *  @param cell     ContestUrlCell to configure
 *  @param property NSDictionary with keys title/data
 */
- (void)configureUrlTableViewCell:(ContestUrlCell*)cell
                               withDictionary:(NSDictionary*)property
{
    cell.descriptionLabel.text = property[@"title"];
    cell.urlLabel.text = property[@"data"];
    cell.url = [NSURL URLWithString:property[@"data"]];
}

/**
 * Configure a Candidate cell
 *
 * TODO: Add appropriate styling -- do this in a subclass of UITableViewCell
 */
- (void)configureCandidateTableViewCell:(UITableViewCell*)cell
                                       withCandidate:(Candidate*)candidate
{
    cell.textLabel.text = candidate.name;
    cell.detailTextLabel.text = candidate.party;
    UIImage* candidateImage = [UIImage imageWithData:candidate.photo];
    if (candidateImage) {
        cell.imageView.image = candidateImage;
    }
}

#pragma mark - Segues
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Segue to the CandidateDetails view
    if ([segue.identifier isEqualToString:@"CandidateDetailsSegue"]) {
        CandidateDetailsViewController* cdvc =
        (CandidateDetailsViewController*) segue.destinationViewController;

        UITableViewCell *cell = (UITableViewCell*)sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        cdvc.candidate = self.tableData[indexPath.section][indexPath.item];

    // Segue displays webview for a url contest property
    } else if ([segue.identifier isEqualToString:@"ContestUrlCellSegue"]) {
        UIWebViewController *webView = (UIWebViewController*) segue.destinationViewController;
        ContestUrlCell *cell = (ContestUrlCell*)sender;
        webView.title = NSLocalizedString(@"Website", nil);
        webView.url = cell.url;
    }
}

@end
