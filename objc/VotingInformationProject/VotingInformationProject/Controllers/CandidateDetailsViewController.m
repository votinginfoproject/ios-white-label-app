//
//  CandidateDetailsViewController.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/17/14.
//

#import "CandidateDetailsViewController.h"

#import "UIWebViewController.h"
#import "VIPEmptyCandidateDataSource.h"


@interface CandidateDetailsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *candidatePhoto;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *affiliationLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray* tableData;
@property (assign, nonatomic) BOOL isCandidatesEmpty;
@property (assign, nonatomic) BOOL isSocialEmpty;

@end

@implementation CandidateDetailsViewController

NSUInteger const CDVC_TABLECELL_HEIGHT_EMPTY = 88;
NSUInteger const CDVC_TABLECELL_HEIGHT_DEFAULT = 44;
NSUInteger const CDVC_TABLE_SECTION_LINKS = 0;
NSUInteger const CDVC_TABLE_SECTION_SOCIAL = 1;
NSString * const CDVC_TABLE_CELLID_LINKS = @"CandidateLinksCell";
NSString * const CDVC_TABLE_CELLID_SOCIAL = @"CandidateSocialCell";
NSString * const CDVC_TABLE_CELLID_LINKS_EMPTY = @"CandidateLinksCellEmpty";
NSString * const CDVC_TABLE_CELLID_SOCIAL_EMPTY = @"CandidateSocialCellEmpty";

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

    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    // Setting an empty footer removes extraneous empty cells from filling
    // the available view space
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    [self updateUI];
}

/**
 *  Update the tableData array that sources the TableView
 */
- (void) updateData
{
    [self.tableData removeAllObjects];
    NSArray* links = [self.candidate getLinksDataArray];
    [self.tableData addObject:links];

    NSArray* channels = [self.candidate getSorted:@"socialChannels" byProperty:@"type" ascending:YES];
    if (channels) {
        [self.tableData addObject:channels];
    }
}

/**
 *  Update the UI with changes to the underlying data
 */
- (void) updateUI
{
    [self updateData];

    self.nameLabel.text = self.candidate.name
        ? self.candidate.name : NSLocalizedString(@"Not Available", nil);

    self.affiliationLabel.text = self.candidate.party
        ? self.candidate.party : NSLocalizedString(@"No Party Information Available", nil);

    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_tableData count];
}

- (void)setIsEmpty:(BOOL)isEmpty forSection:(NSInteger)section
{
    if (section == CDVC_TABLE_SECTION_LINKS) {
        self.isCandidatesEmpty = isEmpty;
    } else if (section == CDVC_TABLE_SECTION_SOCIAL) {
        self.isSocialEmpty = isEmpty;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSUInteger rows = [_tableData[section] count];
    if (rows == 0) {
        [self setIsEmpty:YES forSection:section];
        return 1;
    } else {
        [self setIsEmpty:NO forSection:section];
        return rows;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = [indexPath section];
    NSString *cellIdentifier = [self cellIdentifierFor:section];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];

    if (section == CDVC_TABLE_SECTION_LINKS && !self.isCandidatesEmpty) {
        NSDictionary* link = self.tableData[indexPath.section][indexPath.item];
        CandidateLinkCell* linkCell = (CandidateLinkCell*)cell;
        [linkCell configure:link];
    } else if (section == CDVC_TABLE_SECTION_SOCIAL && !self.isSocialEmpty) {
        SocialChannel* socialChannel = self.tableData[indexPath.section][indexPath.item];
        CandidateSocialCell* socialCell = (CandidateSocialCell*)cell;
        [socialCell configure:socialChannel];
    }
    return cell;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == CDVC_TABLE_SECTION_LINKS) {
        return NSLocalizedString(@"Candidate Details", nil);
    } else if (section == CDVC_TABLE_SECTION_SOCIAL) {
        return NSLocalizedString(@"Social Media Channels", nil);
    }
    return @"";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = [indexPath section];
    if (section == CDVC_TABLE_SECTION_LINKS && self.isCandidatesEmpty) {
        return CDVC_TABLECELL_HEIGHT_EMPTY;
    } else if (section == CDVC_TABLE_SECTION_SOCIAL && self.isSocialEmpty) {
        return CDVC_TABLECELL_HEIGHT_EMPTY;
    } else {
        return CDVC_TABLECELL_HEIGHT_DEFAULT;
    }
}

/**
 * @param section Table section returned by the table view
 * @return NSString* cell identifier for the passed section
 */
- (NSString*)cellIdentifierFor:(NSInteger) section
{
    if (section == CDVC_TABLE_SECTION_LINKS && self.isCandidatesEmpty) {
        return CDVC_TABLE_CELLID_LINKS_EMPTY;
    } else if (section == CDVC_TABLE_SECTION_LINKS) {
        return CDVC_TABLE_CELLID_LINKS;
    } else if (section == CDVC_TABLE_SECTION_SOCIAL && self.isSocialEmpty) {
        return CDVC_TABLE_CELLID_SOCIAL_EMPTY;
    } else if (section == CDVC_TABLE_SECTION_SOCIAL) {
        return CDVC_TABLE_CELLID_SOCIAL;
    }
    return nil;
}

#pragma mark - Segues
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"CandidateSocialSegue"]) {
        // TODO: Open links in specific apps if available, rather than web browser
        //       http://wiki.akosma.com/IPhone_URL_Schemes
        CandidateSocialCell *cell = (CandidateSocialCell*)sender;
        UIWebViewController *webView = (UIWebViewController*)segue.destinationViewController;
        webView.url = cell.url;
        webView.title = NSLocalizedString(@"Social", nil);
    }
}


@end
