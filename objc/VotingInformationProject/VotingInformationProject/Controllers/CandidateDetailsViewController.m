//
//  CandidateDetailsViewController.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/17/14.
//

#import "CandidateDetailsViewController.h"

#import "UIWebViewController.h"
#import "VIPColor.h"


@interface CandidateDetailsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *candidatePhoto;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *affiliationLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray* tableData;

@end

@implementation CandidateDetailsViewController

NSUInteger const CDVC_TABLE_HEADER_HEIGHT = 32;
NSUInteger const CDVC_TABLE_FOOTER_LINKS_HEIGHT = 19;
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

    self.screenName = @"Candidate Details Screen";

    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    self.nameLabel.textColor = [VIPColor primaryTextColor];
    self.affiliationLabel.textColor = [VIPColor secondaryTextColor];

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
        ? [self.candidate.name capitalizedString] : NSLocalizedString(@"Not Available", @"Displays in place of candidate's name when candidate's name not found");

    self.affiliationLabel.text = self.candidate.party
        ? self.candidate.party : NSLocalizedString(@"No Party Information Available", @"Displays in place of candidate's party affiliation when candidate's party is not found");
    self.affiliationLabel.text = [self.affiliationLabel.text uppercaseString];

    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_tableData count];
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
    if ([self isSectionEmpty:section]) {
        return 1;
    } else {
        return [self.tableData[section] count];
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIColor *primaryTextColor = [VIPColor primaryTextColor];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, CDVC_TABLE_HEADER_HEIGHT)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, tableView.frame.size.width, CDVC_TABLE_HEADER_HEIGHT)];
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = primaryTextColor;
    label.text = [self titleForHeaderInSection:section];
    [view addSubview:label];
    [view setBackgroundColor:[VIPColor tableHeaderColor]];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CDVC_TABLE_HEADER_HEIGHT;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = [indexPath section];
    NSString *cellIdentifier = [self cellIdentifierFor:section];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];

    BOOL isSectionEmpty = [self isSectionEmpty:section];
    if (section == CDVC_TABLE_SECTION_LINKS && !isSectionEmpty) {
        NSDictionary* link = self.tableData[indexPath.section][indexPath.item];
        CandidateLinkCell* linkCell = (CandidateLinkCell*)cell;
        [linkCell configure:link];
    } else if (section == CDVC_TABLE_SECTION_SOCIAL && !isSectionEmpty) {
        SocialChannel* socialChannel = self.tableData[indexPath.section][indexPath.item];
        CandidateSocialCell* socialCell = (CandidateSocialCell*)cell;
        [socialCell configure:socialChannel];
    }
    return cell;
}

- (NSString*)titleForHeaderInSection:(NSInteger)section
{
    if (section == CDVC_TABLE_SECTION_LINKS) {
        return NSLocalizedString(@"Candidate Details", @"Section header for candidate's details");
    } else if (section == CDVC_TABLE_SECTION_SOCIAL) {
        return NSLocalizedString(@"Social Media Channels",
                                 @"Section header for candidate's social media information");
    }
    return @"";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = [indexPath section];
    BOOL isSectionEmpty = [self isSectionEmpty:section];
    if (section == CDVC_TABLE_SECTION_LINKS && isSectionEmpty) {
        return CDVC_TABLECELL_HEIGHT_EMPTY;
    } else if (section == CDVC_TABLE_SECTION_SOCIAL && isSectionEmpty) {
        return CDVC_TABLECELL_HEIGHT_EMPTY;
    } else {
        return CDVC_TABLECELL_HEIGHT_DEFAULT;
    }
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == CDVC_TABLE_SECTION_LINKS) {
        CGRect propertiesCGRect = CGRectMake(0.0, 0,
                                             tableView.bounds.size.width,
                                             CDVC_TABLE_FOOTER_LINKS_HEIGHT);
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
    if (section == CDVC_TABLE_SECTION_LINKS && isSectionEmpty) {
        return CDVC_TABLE_CELLID_LINKS_EMPTY;
    } else if (section == CDVC_TABLE_SECTION_LINKS) {
        return CDVC_TABLE_CELLID_LINKS;
    } else if (section == CDVC_TABLE_SECTION_SOCIAL && isSectionEmpty) {
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
        webView.title = NSLocalizedString(@"Social", @"Title for browser window when viewing canditate's social media site");
    }
}


@end
