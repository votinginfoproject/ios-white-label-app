//
//  ContestDetailsViewController.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/13/14.
//

#import "ContestDetailsViewController.h"

#import "VIPTabBarController.h"
#import "CandidateDetailsViewController.h"
#import "UIWebViewController.h"
#import "ContestUrlCell.h"
#import "VIPCandidateCell.h"
#import "VIPColor.h"


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

NSUInteger const CODVC_TABLE_HEADER_HEIGHT = 32;
NSUInteger const CODVC_TABLECELL_HEIGHT_EMPTY = 88;
NSUInteger const CODVC_TABLECELL_HEIGHT_CANDIDATES = 64;
NSUInteger const CODVC_TABLECELL_HEIGHT_DEFAULT = 44;
NSString * const CDVC_TABLE_CELLID_PROPERTIES = @"ContestPropertiesCell";
NSString * const CDVC_TABLE_CELLID_PROPERTIES_EMPTY = @"ContestPropertiesCellEmpty";
NSUInteger const CDVC_TABLE_SECTION_PROPERTIES = 0;
NSString * const CDVC_TABLE_CELLID_CANDIDATES = @"VIPCandidateCell";
NSString * const CDVC_TABLE_CELLID_CANDIDATES_EMPTY = @"CandidateCellEmpty";
NSUInteger const CDVC_TABLE_SECTION_CANDIDATES = 1;
NSUInteger const CDVC_TABLE_FOOTER_DEFAULT_HEIGHT = 0;
NSUInteger const CDVC_TABLE_FOOTER_PROPERTIES_HEIGHT = 19;
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

    self.screenName = @"Contest Details Screen";

    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    self.contestNameLabel.textColor = [VIPColor primaryTextColor];
    self.electionNameLabel.textColor = [VIPColor secondaryTextColor];

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
    self.electionNameLabel.text = [self.electionNameLabel.text uppercaseString];
    [self.tableData addObject:[self.contest getProperties]];

    if ([self.contest.type isEqualToString:REFERENDUM_API_ID]) {
        self.contestNameLabel.text = self.contest.referendumTitle;
        self.title = NSLocalizedString(@"Referendum", @"Contest details referendum section title");
    } else {
        self.contestNameLabel.text = self.contest.office ?: NSLocalizedString(@"Not Available",
                                                                              @"Contest details text displayed when office name not available");
        // Only add candidates for elections, not referenda
        NSSortDescriptor *candidatesSort = [NSSortDescriptor sortDescriptorWithKey:@"orderOnBallot" ascending:YES];
        NSArray *sortedCandidates = [self.contest.candidates sortedArrayUsingDescriptors:@[candidatesSort]];
        if (sortedCandidates) {
            [self.tableData addObject:sortedCandidates];
        }
    }
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.tableData count];
}

- (BOOL)isSectionEmpty:(NSInteger)section
{
    NSUInteger sections = [self.tableData count];
    if (section >= sections || section < 0) {
        return YES;
    }
    return ([self.tableData[section] count] == 0);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSUInteger rows = [self.tableData[section] count];
    if (rows == 0) {
        return 1;
    } else {
        return rows;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = [indexPath section];

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

    UITableViewCell *cell = nil;
    NSString *cellIdentifier = [self cellIdentifierFor:section];
    // If we have a url, make this cell segue to UIWebViewController
    BOOL isSectionEmpty = [self isSectionEmpty:section];
    if (section == CDVC_TABLE_SECTION_PROPERTIES &&
        ([dataUrl.scheme isEqualToString:@"http"] ||
         [dataUrl.scheme isEqualToString:@"https"])) {
        cell = [tableView dequeueReusableCellWithIdentifier:CONTEST_URL_CELLID
                                               forIndexPath:indexPath];
        ContestUrlCell *urlCell = (ContestUrlCell*)cell;
        [urlCell configure:property[@"title"] withUrl:property[@"data"]];
    } else if (section == CDVC_TABLE_SECTION_PROPERTIES && !isSectionEmpty) {
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier
                                               forIndexPath:indexPath];
        [self configurePropertiesTableViewCell:cell withDictionary:property];
    } else if (section == CDVC_TABLE_SECTION_CANDIDATES && !isSectionEmpty) {
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier
                                               forIndexPath:indexPath];
        Candidate *candidate = (Candidate *)self.tableData[section][indexPath.item];
        VIPCandidateCell *candidateCell = (VIPCandidateCell*)cell;
        [self configureCandidateTableViewCell:candidateCell withCandidate:candidate];
    }
    return cell;
}

- (NSString*)titleForHeaderInSection:(NSInteger)section
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

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIColor *primaryTextColor = [VIPColor primaryTextColor];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, CODVC_TABLE_HEADER_HEIGHT)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, tableView.frame.size.width, CODVC_TABLE_HEADER_HEIGHT)];
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = primaryTextColor;
    label.text = [self titleForHeaderInSection:section];
    [view addSubview:label];
    [view setBackgroundColor:[VIPColor tableHeaderColor]];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CODVC_TABLE_HEADER_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = [indexPath section];
    BOOL isSectionEmpty = [self isSectionEmpty:section];
    if (section == CDVC_TABLE_SECTION_CANDIDATES && isSectionEmpty) {
        return CODVC_TABLECELL_HEIGHT_EMPTY;
    } else if (section == CDVC_TABLE_SECTION_PROPERTIES && isSectionEmpty) {
        return CODVC_TABLECELL_HEIGHT_EMPTY;
    } else if (section == CDVC_TABLE_SECTION_CANDIDATES){
        return CODVC_TABLECELL_HEIGHT_CANDIDATES;
    } else {
        return CODVC_TABLECELL_HEIGHT_DEFAULT;
    }
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == CDVC_TABLE_SECTION_PROPERTIES) {
        CGRect propertiesCGRect = CGRectMake(0.0, 0, tableView.bounds.size.width, CDVC_TABLE_FOOTER_PROPERTIES_HEIGHT);
        UIView *propertiesFooterView = [[UIView alloc] initWithFrame:propertiesCGRect];
        propertiesFooterView.backgroundColor = [UIColor clearColor];
        return propertiesFooterView;
    }
    return [[UIView alloc] initWithFrame:CGRectZero];
}

/**
 * @param section Table section returned by the table view
 * @return NSString* cell identifier for the passed section
 */
- (NSString*)cellIdentifierFor:(NSInteger) section
{
    BOOL isSectionEmpty = [self isSectionEmpty:section];
    if (section == CDVC_TABLE_SECTION_PROPERTIES && isSectionEmpty) {
        return CDVC_TABLE_CELLID_PROPERTIES_EMPTY;
    } else if (section == CDVC_TABLE_SECTION_PROPERTIES) {
        return CDVC_TABLE_CELLID_PROPERTIES;
    } else if (section == CDVC_TABLE_SECTION_CANDIDATES && isSectionEmpty) {
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
    cell.textLabel.textColor = [VIPColor primaryTextColor];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.detailTextLabel.text = [property[@"data"] capitalizedString];
    cell.detailTextLabel.textColor = [VIPColor primaryTextColor];
    cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:16];
}

/**
 * Configure a Candidate cell
 *
 * TODO: Add appropriate styling -- do this in a subclass of UITableViewCell
 */
- (void)configureCandidateTableViewCell:(VIPCandidateCell*)cell
                                       withCandidate:(Candidate*)candidate
{
    cell.nameLabel.font = [UIFont systemFontOfSize:17.0];
    cell.nameLabel.text = [candidate.name capitalizedString];
    cell.partyLabel.font = [UIFont boldSystemFontOfSize:12.0];
    cell.partyLabel.text = [candidate.party capitalizedString];
    UIImage* candidateImage = [UIImage imageWithData:candidate.photo];
    if (candidateImage) {
        cell.photoView.image = candidateImage;
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
        Candidate *candidate = self.tableData[indexPath.section][indexPath.item];
        cdvc.candidate = candidate;

    } else if ([segue.identifier isEqualToString:@"ContestUrlCellSegue"]) {
        UIWebViewController *webView = (UIWebViewController*) segue.destinationViewController;
        ContestUrlCell *cell = (ContestUrlCell*)sender;
        webView.title = cell.textLabel.text;
        webView.url = cell.url;
    }
}

@end
