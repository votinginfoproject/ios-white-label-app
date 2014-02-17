//
//  CandidateDetailsViewController.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/17/14.
//  Copyright (c) 2014 Bennet Huber. All rights reserved.
//

#import "CandidateDetailsViewController.h"

#define CDVC_TABLE_SECTION_LINKS 0
#define CDVC_TABLE_CELLID_LINKS @"CandidateLinksCell"
#define CDVC_TABLE_SECTION_SOCIAL 1
#define CDVC_TABLE_CELLID_SOCIAL @"CandidateSocialCell"

@interface CandidateDetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *candidatePhoto;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *affiliationLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray* tableData;

@end

@implementation CandidateDetailsViewController

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
	// Do any additional setup after loading the view.

    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    [self updateUI];
}

- (void) updateData
{
    [self.tableData removeAllObjects];
    NSArray* links = [self.candidate getLinksDataArray];
    [self.tableData addObject:links];

    // TODO: Remove after testing
    if ([self.candidate.socialChannels count] == 0) {
        SocialChannel *twitter =
        (SocialChannel*)[SocialChannel setFromDictionary:@{@"type": @"Twitter", @"id": @"@NHLFlyers"}];
        [self.candidate addSocialChannelsObject:twitter];
        SocialChannel *facebook =
        (SocialChannel*)[SocialChannel setFromDictionary:@{@"type": @"Facebook", @"id": @"philadelphiaflyers"}];
        [self.candidate addSocialChannelsObject:facebook];
    }

    NSArray* channels = [self.candidate getSorted:@"socialChannels" byProperty:@"type" ascending:YES];
    if (channels && [channels count] > 0) {
        [self.tableData addObject:channels];
    }
}

- (void) updateUI
{
    [self updateData];

    self.nameLabel.text = self.candidate.name ?: NSLocalizedString(@"Not Available", nil);
    self.affiliationLabel.text = self.candidate.party ?: NSLocalizedString(@"No Party Information Available", nil);
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

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = [indexPath section];
    NSString *cellIdentifier = [self cellIdentifierFor:section];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];

    if (section == CDVC_TABLE_SECTION_LINKS) {
        // TODO: Implement links table cell assignments
    } else if (section == CDVC_TABLE_SECTION_SOCIAL) {
        // TODO: Implement social table cell assignments
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

/**
 * @param section Table section returned by the table view
 * @return NSString* cell identifier for the passed section
 */
- (NSString*)cellIdentifierFor:(NSInteger) section
{
    if (section == CDVC_TABLE_SECTION_LINKS) {
        return CDVC_TABLE_CELLID_LINKS;
    } else if (section == CDVC_TABLE_SECTION_SOCIAL) {
        return CDVC_TABLE_CELLID_SOCIAL;
    }
    return nil;
}

@end
