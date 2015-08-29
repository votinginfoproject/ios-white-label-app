//
//  BallotViewController.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/7/14.
//

#import "BallotViewController.h"
#import "ContactsSearchViewController.h"
#import "ContestDetailsViewController.h"
#import "VIPEmptyTableViewDataSource.h"
#import "UIWebViewController.h"
#import "UserElection+API.h"
#import "Election+API.h"
#import "Contest+API.h"
#import "VIPColor.h"
#import "VIPUserDefaultsKeys.h"
#import "VIPContestCell.h"

@interface BallotViewController ()
@property (strong, nonatomic) NSString *party;
@property (strong, nonatomic) NSMutableDictionary *offscreenCells;
@property (weak, nonatomic) IBOutlet UILabel *electionNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *electionDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *selectedPartyLabel;
@property (strong, nonatomic) VIPEmptyTableViewDataSource *emptyDataSource;
@end

@implementation BallotViewController {
    NSArray *_contests;
}

const NSUInteger VIP_BALLOT_TABLECELL_HEIGHT = 44;

static UIFont *kTitleFont;
static UIFont *kSubtitleFont;


+ (void)initialize {
    kTitleFont              = [UIFont boldSystemFontOfSize:16];
    kSubtitleFont           = [UIFont systemFontOfSize:15];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        _offscreenCells = @{}.mutableCopy;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.emptyDataSource = [[VIPEmptyTableViewDataSource alloc]
                            initWithEmptyMessage:NSLocalizedString(@"No Contests Available",
                                                                   @"Text displayed by the table view if there are no contests to display")];

    self.screenName = @"Ballot Screen";
    self.electionNameLabel.textColor = [VIPColor primaryTextColor];
    self.electionDateLabel.textColor = [VIPColor secondaryTextColor];
    self.selectedPartyLabel.textColor = [VIPColor secondaryTextColor];

    self.tableView.tableFooterView =[VIPFeedbackView inView:self.tableView
                                               withDelegate:self];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.tabBarController) {
        self.tabBarController.title = NSLocalizedString(@"Ballot", @"Name for bottom-left tab (ballot)");
    }

    VIPTabBarController *vipTabBarController = (VIPTabBarController *)self.tabBarController;

    if (![vipTabBarController isVIPDataAvailable]) {
        [self presentContactsSearchViewController];
    } else {
        self.election = (UserElection*) vipTabBarController.currentElection;
        self.party = vipTabBarController.currentParty;
        [self updateUI];
    }
}

- (void)setParty:(NSString *)party
{
    _party = party;
    self.selectedPartyLabel.text = [party uppercaseString];
}

- (id<UITableViewDataSource>)configureDataSource
{
    return ([_contests count] > 0) ? self : self.emptyDataSource;
}

/**
 *  Update UI with new contests
 */
- (void) updateUI
{
    if (!self.election) {
        return;
    }

    self.electionNameLabel.text = self.election.election.name;
    self.electionDateLabel.text = [self.election.election getDateString];

    NSSortDescriptor *contestsSort = [NSSortDescriptor sortDescriptorWithKey:@"ballotPlacement"
                                                                   ascending:YES];
    NSArray *contests = [self.election.contests sortedArrayUsingDescriptors:@[contestsSort]];

    if ([self.party length] > 0) {
        NSString *predicateFormat = @"SELF.primaryParty = nil OR SELF.primaryParty CONTAINS[cd] %@";
        NSPredicate *partyFilterPredicate = [NSPredicate
                                             predicateWithFormat:predicateFormat, self.party];

        contests = [contests filteredArrayUsingPredicate:partyFilterPredicate];
    }
    _contests = contests;
    self.tableView.dataSource = [self configureDataSource];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ContactsSearchViewControllerDelegate

/* 
 * NOTE:
 * This delegate function call and the HomeSegue if block in the prepareForSegue method below are in
 * all of the tab bar root view controllers for each tab stack. I couldn't come up with
 * a good way to DRY it out so that there was only one instance of the "Home" button for
 * all of the tab navigation controllers. Each of the root view controllers has a separate
 * instance of that home button as well as a modal "HomeSegue" defined.
 * If someone has a good solution to this, please share.
 *
 * Tried:
 *  - Subclassing navigation controller, but that requires a bunch of logic to only display
 *    the button contionally on the root view
 *  - Superclassing each of the tab root controllers, but this is also messy because we have a mix
 *    of UIViewControllers and UITableViewControllers
 *
 */
- (void)contactsSearchViewControllerDidClose:(ContactsSearchViewController *)controller
                               withElections:(NSArray *)elections
                             currentElection:(UserElection *)election
                                    andParty:(NSString *)party
{
    VIPTabBarController *vipTabBarController = (VIPTabBarController*)self.tabBarController;
    vipTabBarController.elections = elections;
    vipTabBarController.currentElection = election;
    vipTabBarController.currentParty = party;
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - VIPFeedbackViewDelegate

- (void)sendFeedback:(VIPFeedbackView *)view
{
    NSMutableURLRequest *request = [self.election getFeedbackRequest];
    [self performSegueWithIdentifier:VIP_FEEDBACK_SEGUE sender:request];
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
    return [_contests count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdentifier = @"ContestCell";
    VIPContestCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];

    
    Contest *contest = _contests[indexPath.item];
    NSString *title = [contest.type isEqualToString:REFERENDUM_API_ID]
        ? contest.referendumTitle : contest.office;
    cell.textLabel.text = title;
    cell.textLabel.font = kTitleFont;

    NSString *detailLabel = [contest.type isEqualToString:REFERENDUM_API_ID] ? contest.referendumBrief : contest.type;

    cell.detailTextLabel.text = detailLabel;
    cell.detailTextLabel.font = kSubtitleFont;

    cell.textLabel.preferredMaxLayoutWidth = CGRectGetWidth(tableView.bounds);
    cell.detailTextLabel.preferredMaxLayoutWidth = CGRectGetWidth(tableView.bounds);

    [cell setNeedsLayout];
    [cell updateConstraintsIfNeeded];

    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Contest *contest = _contests[indexPath.item];
    NSString *title = [contest.type isEqualToString:REFERENDUM_API_ID]
    ? contest.referendumTitle : contest.office;
    NSString *detailLabel = [contest.type isEqualToString:REFERENDUM_API_ID] ? contest.referendumBrief : contest.type;

    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;

    CGRect titleRect = [title boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 100, CGFLOAT_MAX)
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                attributes:@{NSFontAttributeName:kTitleFont, NSParagraphStyleAttributeName:paragraph}
                                                   context:NULL];

    CGRect detailRect = [detailLabel boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 100, CGFLOAT_MAX)
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{NSFontAttributeName:kSubtitleFont, NSParagraphStyleAttributeName:paragraph}
                                           context:NULL];

    if ((_contests.count) > 0) {
        return titleRect.size.height + detailRect.size.height + 20;
    } else {
        return VIP_EMPTY_TABLECELL_HEIGHT;
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
    if ((_contests.count) > 0) {
        return 44.f;
    } else {
        return VIP_EMPTY_TABLECELL_HEIGHT;
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"HomeSegue"]) {
        ContactsSearchViewController *csvc = (ContactsSearchViewController*) segue.destinationViewController;
        csvc.delegate = self;
        VIPTabBarController *vipTabBarController = (VIPTabBarController*)self.tabBarController;
        csvc.currentElection = vipTabBarController.currentElection;
    } else if ([segue.identifier isEqualToString:@"ContestDetailsSegue"]) {
        ContestDetailsViewController *cdvc = (ContestDetailsViewController*) segue.destinationViewController;
        UITableViewCell *cell = (UITableViewCell*)sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        Contest *contest = (Contest*)_contests[indexPath.item];
        cdvc.contest = contest;
        cdvc.electionName = self.election.election.name;
    } else if ([segue.identifier isEqualToString:VIP_FEEDBACK_SEGUE]) {
        UIWebViewController *webView = (UIWebViewController*) segue.destinationViewController;
        webView.title = NSLocalizedString(@"Feedback", @"Title for web view displaying the VIP election feedback form");
        webView.request = (NSMutableURLRequest*)sender;
    }
}

- (void)presentContactsSearchViewController
{
    UIStoryboard *storyboard = self.storyboard;
    ContactsSearchViewController *csvc = [storyboard instantiateViewControllerWithIdentifier:@"ContactsSearchViewController"];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:csvc];
    csvc.delegate = self;
    [self presentViewController:navigationController animated:NO completion:nil];
}

@end
