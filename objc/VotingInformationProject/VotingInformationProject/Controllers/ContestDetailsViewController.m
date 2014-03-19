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
@property (assign, nonatomic) BOOL isPropertiesEmpty;
@property (assign, nonatomic) BOOL isCandidatesEmpty;

// tableData is a 2d array where:
//  first dimension is # of sections
//  second dimension is data for each section
@property (strong, nonatomic) NSMutableArray *tableData;

@end

@implementation ContestDetailsViewController

NSUInteger const CODVC_TABLECELL_HEIGHT_EMPTY = 88;
NSUInteger const CODVC_TABLECELL_HEIGHT_DEFAULT = 44;
NSString * const CDVC_TABLE_CELLID_PROPERTIES = @"ContestPropertiesCell";
NSString * const CDVC_TABLE_CELLID_PROPERTIES_EMPTY = @"ContestPropertiesCellEmpty";
NSUInteger const CDVC_TABLE_SECTION_PROPERTIES = 0;
NSString * const CDVC_TABLE_CELLID_CANDIDATES = @"CandidateCell";
NSString * const CDVC_TABLE_CELLID_CANDIDATES_EMPTY = @"CandidateCellEmpty";
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

    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
    self.electionNameLabel.text = self.electionName ?: NSLocalizedString(@"Not Available",
                                                                         @"Contest details text displayed when election name not available");
    [self.tableData addObject:[self.contest getProperties]];

    if ([self.contest.type isEqualToString:REFERENDUM_API_ID]) {
        self.contestNameLabel.text = self.contest.referendumTitle;
        self.title = NSLocalizedString(@"Referendum", @"Contest details referendum section title");
    } else {
        self.contestNameLabel.text = self.contest.office ?: NSLocalizedString(@"Not Available",
                                                                              @"Contest details text displayed when office name not available");
        // Only add candidates for elections, not referenda
        [self.tableData addObject:[self.contest getSorted:@"candidates"
                                               byProperty:@"name"
                                                ascending:YES]];
    }
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.tableData count];
}

- (void)setIsEmpty:(BOOL)isEmpty forSection:(NSInteger)section
{
    if (section == CDVC_TABLE_SECTION_PROPERTIES) {
        self.isPropertiesEmpty = isEmpty;
    } else if (section == CDVC_TABLE_SECTION_CANDIDATES) {
        self.isCandidatesEmpty = isEmpty;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSUInteger rows = [self.tableData[section] count];
    if (rows == 0) {
        [self setIsEmpty:YES forSection:section];
        return 1;
    } else {
        [self setIsEmpty:NO forSection:section];
        return rows;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = [indexPath section];
    NSString *cellIdentifier = [self cellIdentifierFor:section];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];

    NSArray *data = self.tableData[section];
    NSDictionary *property = nil;
    // Check if we can make a url from the data property
    NSURL *dataUrl = nil;
    if (data && [data count] > 0) {
        property = (NSDictionary *)data[indexPath.item];
        if ([property isKindOfClass:[NSDictionary class]]) {
            dataUrl = [NSURL URLWithString:property[@"data"]];
        }
    }

    // If we have a url, make this cell segue to UIWebViewController
    if (section == CDVC_TABLE_SECTION_PROPERTIES && dataUrl.scheme && [dataUrl.scheme length] > 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:CONTEST_URL_CELLID forIndexPath:indexPath];
        ContestUrlCell *urlCell = (ContestUrlCell*)cell;
        [urlCell configure:property[@"title"] withUrl:property[@"data"]];
    } else if (section == CDVC_TABLE_SECTION_PROPERTIES && !self.isPropertiesEmpty) {
        [self configurePropertiesTableViewCell:cell withDictionary:property];
    } else if (section == CDVC_TABLE_SECTION_CANDIDATES && !self.isCandidatesEmpty) {
        Candidate *candidate = (Candidate *)self.tableData[section][indexPath.item];
        [self configureCandidateTableViewCell:cell withCandidate:candidate];
    }
    return cell;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == CDVC_TABLE_SECTION_PROPERTIES && [self.contest.type isEqualToString:REFERENDUM_API_ID]) {
        return NSLocalizedString(@"Referendum Details", @"Section title for referendum details");
    } else if (section == CDVC_TABLE_SECTION_PROPERTIES) {
        return NSLocalizedString(@"Contest Details", @"Section title for contest details");
    } else if (section == CDVC_TABLE_SECTION_CANDIDATES) {
        return NSLocalizedString(@"Candidates", @"Section title for candidates' details");
    }
    return @"";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = [indexPath section];
    if (section == CDVC_TABLE_SECTION_CANDIDATES && self.isCandidatesEmpty) {
        return CODVC_TABLECELL_HEIGHT_EMPTY;
    } else if (section == CDVC_TABLE_SECTION_PROPERTIES && self.isPropertiesEmpty) {
        return CODVC_TABLECELL_HEIGHT_EMPTY;
    } else {
        return CODVC_TABLECELL_HEIGHT_DEFAULT;
    }
}

/**
 * @param section Table section returned by the table view
 * @return NSString* cell identifier for the passed section
 */
- (NSString*)cellIdentifierFor:(NSInteger) section
{
    if (section == CDVC_TABLE_SECTION_PROPERTIES && self.isPropertiesEmpty) {
        return CDVC_TABLE_CELLID_PROPERTIES_EMPTY;
    } else if (section == CDVC_TABLE_SECTION_PROPERTIES) {
        return CDVC_TABLE_CELLID_PROPERTIES;
    } else if (section == CDVC_TABLE_SECTION_CANDIDATES && self.isCandidatesEmpty) {
        return CDVC_TABLE_CELLID_CANDIDATES_EMPTY;
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

/**
 *  Segues for:
 *      CandidateDetailsSegue to CandidateDetails view
 *      ContestUrlCellSegue to UIWebViewController
 *
 *  @param segue  segue
 *  @param sender sender object
 */
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"CandidateDetailsSegue"]) {
        CandidateDetailsViewController* cdvc =
        (CandidateDetailsViewController*) segue.destinationViewController;

        UITableViewCell *cell = (UITableViewCell*)sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        cdvc.candidate = self.tableData[indexPath.section][indexPath.item];

    } else if ([segue.identifier isEqualToString:@"ContestUrlCellSegue"]) {
        UIWebViewController *webView = (UIWebViewController*) segue.destinationViewController;
        ContestUrlCell *cell = (ContestUrlCell*)sender;
        webView.title = NSLocalizedString(@"Website", @"Title when viewing contest web page");
        webView.url = cell.url;
    }
}

@end
