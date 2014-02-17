//
//  ContestDetailsViewController.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/13/14.
//

#import "ContestDetailsViewController.h"

#define CDVC_TABLE_SECTION_PROPERTIES 0
#define CDVC_TABLE_CELLID_PROPERTIES @"ContestPropertiesCell"
#define CDVC_TABLE_SECTION_CANDIDATES 1
#define CDVC_TABLE_CELLID_CANDIDATES @"CandidateCell"

@interface ContestDetailsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *contestNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *electionNameLabel;

@end

@implementation ContestDetailsViewController {
    NSMutableArray *_tableData; // 2D array:    first dimension is an array for each section
                                //              second dimension is data for that section
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
    self.electionNameLabel.text = self.electionName;

    _tableData = [[NSMutableArray alloc] initWithCapacity:2];
    [_tableData addObject:[self.contest getPropertiesDataArray]];
    [_tableData addObject:[self.contest getSorted:@"candidates"
                                       byProperty:@"name"
                                        ascending:YES]];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_tableData count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_tableData[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = [indexPath section];
    NSString *cellIdentifier = [self cellIdentifierFor:section];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];

    if (section == CDVC_TABLE_SECTION_PROPERTIES) {
        NSDictionary *property = (NSDictionary *)_tableData[section][indexPath.item];
        [self configurePropertiesTableViewCell:cell withDictionary:property];
    } else if (section == CDVC_TABLE_SECTION_CANDIDATES) {
        Candidate *candidate = (Candidate *)_tableData[section][indexPath.item];
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
 @param section Table section returned by the table view
 @return NSString* cell identifier for the passed section
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
 Configure one of the contest details cells
 
 TODO: Add appropriate styling -- do this in a subclass of UITableViewCell
 */
- (UITableViewCell*)configurePropertiesTableViewCell:(UITableViewCell*)cell
                                       withDictionary:(NSDictionary*)property
{
    cell.textLabel.text = property[@"title"];
    cell.detailTextLabel.text = property[@"data"];
    return cell;
}

/**
 Configure a Candidate cell
 
 TODO: Add appropriate styling -- do this in a subclass of UITableViewCell
 TODO: Add UIImage for candidate
 */
- (UITableViewCell*)configureCandidateTableViewCell:(UITableViewCell*)cell
                                       withCandidate:(Candidate*)candidate
{
    cell.textLabel.text = candidate.name;
    cell.detailTextLabel.text = candidate.party;
    cell.imageView.image = [UIImage imageWithData:candidate.photo];
    return cell;
}

@end
