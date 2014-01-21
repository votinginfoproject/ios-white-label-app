//
//  FindElectionsViewController.m
//  VoterInformationProject
//
//  Created by Andrew Fink on 1/20/14.
//  Copyright (c) 2014 Bennet Huber. All rights reserved.
//

#import "FindElectionsViewController.h"
#import "AFNetworking/AFNetworking.h"
#import "Election.h"

@interface FindElectionsViewController ()
@property (strong, nonatomic) NSMutableArray *elections;
@property (strong, nonatomic) NSDictionary *appSettings;
@end

@implementation FindElectionsViewController

- (NSMutableArray *) elections {
    if (!_elections) {
        _elections = [[NSMutableArray alloc] init];
    }
    return _elections;
}

- (NSDictionary *) appSettings {
    if (!_appSettings) {
        NSString *settingsPath = [[NSBundle mainBundle] pathForResource:@"settings" ofType:@"plist"];
        _appSettings = [[NSDictionary alloc] initWithContentsOfFile:settingsPath];
    }
    return _appSettings;
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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

    [self loadElectionData];
}

- (void) loadElectionData {

    // Setup request manager
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *requestUrl = [self.appSettings objectForKey:@"ElectionListURL"];
    NSLog(@"URL: %@", requestUrl);
    NSDictionary *requestParams = [self getElectionDataParams:requestUrl];

    [manager GET:requestUrl parameters:requestParams success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {

        // On Success
        NSArray *electionData = [responseObject objectForKey:@"elections"];
        if (!electionData) {
            return;
        }
        for (NSDictionary *entry in electionData) {
            Election *election = [[Election alloc] initWithId:[entry valueForKey:@"id"]
                                                      andName:[entry valueForKey:@"name"]
                                                      andDate:[entry valueForKey:@"electionDay"]];
            [self.elections addObject:election];
        }
        [self.tableView reloadData];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        // On Failure
        // TODO: Better handle errors once UI finalized
        NSLog(@"Error: %@", error);
    }];
}

// If an API Key exists and the url matches the Civic Info API url, then add key to request params
- (NSDictionary*) getElectionDataParams:(NSString*) url {
    NSString *civicInfoElectionQueryURL = [self.appSettings objectForKey:@"GoogleCivicInfoElectionQueryURL"];
    NSString *apiKey = [self.appSettings objectForKey:@"GoogleCivicInfoAPIKey"];
    if (civicInfoElectionQueryURL && apiKey && [url isEqualToString:civicInfoElectionQueryURL]) {
        return @{@"key": apiKey};
    } else {
        return nil;
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
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.elections count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ElectionCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    Election *election = [self.elections objectAtIndex:indexPath.row];
    if (election) {
        cell.textLabel.text = election.name;
    } else {
        cell.textLabel.text = @"Nil";
    }
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
