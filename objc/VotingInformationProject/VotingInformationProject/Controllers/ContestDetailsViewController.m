//
//  ContestDetailsViewController.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/13/14.
//

#import "ContestDetailsViewController.h"

#import "CandidateDetailsViewController.h"

#define CDVC_TABLE_SECTION_PROPERTIES 0
#define CDVC_TABLE_CELLID_PROPERTIES @"ContestPropertiesCell"
#define CDVC_TABLE_SECTION_CANDIDATES 1
#define CDVC_TABLE_CELLID_CANDIDATES @"CandidateCell"

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
 Refresh data displayed in the elements on this view
 */
- (void)updateUI
{
    [self.tableData removeAllObjects];
    self.electionNameLabel.text = self.electionName ?: NSLocalizedString(@"Not Available", nil);
    [self.tableData addObject:[self.contest getContestProperties]];

    if ([self.contest.type isEqualToString:@"Referendum"]) {
        self.contestNameLabel.text = self.contest.referendumTitle;
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
    NSString *cellIdentifier = [self cellIdentifierFor:section];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];

    if (section == CDVC_TABLE_SECTION_PROPERTIES) {
        NSDictionary *property = (NSDictionary *)self.tableData[section][indexPath.item];
        [self configurePropertiesTableViewCell:cell withDictionary:property];
    } else if (section == CDVC_TABLE_SECTION_CANDIDATES) {
        Candidate *candidate = (Candidate *)self.tableData[section][indexPath.item];
        [self configureCandidateTableViewCell:cell withCandidate:candidate];
    }
    return cell;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == CDVC_TABLE_SECTION_PROPERTIES) {
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
- (UITableViewCell*)configurePropertiesTableViewCell:(UITableViewCell*)cell
                                       withDictionary:(NSDictionary*)property
{
    cell.textLabel.text = property[@"title"];
    cell.detailTextLabel.text = property[@"data"];
    return cell;
}

/**
 * Configure a Candidate cell
 *
 * TODO: Add appropriate styling -- do this in a subclass of UITableViewCell
 */
- (UITableViewCell*)configureCandidateTableViewCell:(UITableViewCell*)cell
                                       withCandidate:(Candidate*)candidate
{
    cell.textLabel.text = candidate.name;
    cell.detailTextLabel.text = candidate.party;
    UIImage* candidateImage = [UIImage imageWithData:candidate.photo];
    if (candidateImage) {
        cell.imageView.image = candidateImage;
    }
    return cell;
}

#pragma mark - Segues
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"CandidateDetailsSegue"]) {
        CandidateDetailsViewController* cdvc =
        (CandidateDetailsViewController*) segue.destinationViewController;

        UITableViewCell *cell = (UITableViewCell*)sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        cdvc.candidate = self.tableData[indexPath.section][indexPath.item];
    }
}

@end
