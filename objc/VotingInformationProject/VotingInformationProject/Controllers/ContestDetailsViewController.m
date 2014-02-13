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
    NSDictionary *_displayProperties;
    NSMutableArray *_tableData; // 2D array where first dimension is number of sections
    NSArray *_properties;
    NSArray *_candidates;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    self.electionNameLabel.text = self.electionName;

    NSSortDescriptor *nameDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name"
                                                                     ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:nameDescriptor];
    NSArray *candidates = [self.contest.candidates allObjects];
    _candidates = [candidates sortedArrayUsingDescriptors:sortDescriptors];

    _tableData = [[NSMutableArray alloc] initWithCapacity:2];
    [_tableData addObject:[self createPropertiesDataArray]];
    [_tableData addObject:_candidates];

    self.tabBarItem.title = @"Ballot";

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
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

- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == CDVC_TABLE_SECTION_PROPERTIES) {
        return NSLocalizedString(@"Contest Details", nil);
    } else if (section == CDVC_TABLE_SECTION_CANDIDATES) {
        return NSLocalizedString(@"Candidates", nil);
    }
    return @"";
}

- (NSString*) cellIdentifierFor:(NSInteger) section
{
    if (section == CDVC_TABLE_SECTION_PROPERTIES) {
        return CDVC_TABLE_CELLID_PROPERTIES;
    } else if (section == CDVC_TABLE_SECTION_CANDIDATES) {
        return CDVC_TABLE_CELLID_CANDIDATES;
    }
    return nil;
}

- (UITableViewCell*) configurePropertiesTableViewCell:(UITableViewCell*)cell
                                       withDictionary:(NSDictionary*)property
{
    cell.textLabel.text = property[@"title"];
    cell.detailTextLabel.text = property[@"data"];
    return cell;
}

- (UITableViewCell*) configureCandidateTableViewCell:(UITableViewCell*)cell
                                       withCandidate:(Candidate*)candidate
{
    cell.textLabel.text = candidate.name;
    cell.detailTextLabel.text = candidate.party;
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (NSArray*)createPropertiesDataArray
{
    NSArray *properties = @[
                            @{
                                @"title": NSLocalizedString(@"Type", nil),
                                @"data": self.contest.type
                            },
                            @{
                                @"title": NSLocalizedString(@"Office", nil),
                                @"data": self.contest.office
                            },
                            @{
                                @"title": NSLocalizedString(@"Number Elected", nil),
                                @"data": self.contest.numberElected.stringValue
                            },
                            @{
                                @"title": NSLocalizedString(@"Number Voting For", nil),
                                @"data": self.contest.numberVotingFor.stringValue
                            },
                            @{
                                @"title": NSLocalizedString(@"Ballot Placement", nil),
                                @"data": self.contest.ballotPlacement.stringValue
                            }];
    return properties;

}

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
