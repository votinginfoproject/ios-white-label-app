//
//  FindElectionsViewController.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 1/20/14.
//  Copyright (c) 2014 Bennet Huber. All rights reserved.
//

#import "FindElectionsViewController.h"

@interface FindElectionsViewController ()

@end

@implementation FindElectionsViewController {
    NSArray *_elections;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setOtherElections];
}

- (void) setOtherElections
{
    VIPTabBarController *parentTabBarController = (VIPTabBarController*) self.tabBarController;
    NSArray *elections = parentTabBarController.elections;
    NSUInteger numElections = [elections count];
    if (numElections > 1) {
        NSRange rangeForOtherElections;
        rangeForOtherElections.location = 1;
        rangeForOtherElections.length = [elections count] - 1;
        _elections = [elections subarrayWithRange:rangeForOtherElections];
    } else {
        _elections = @[];
    }
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.tabBarController) {
        self.tabBarController.title = NSLocalizedString(@"More Elections", nil);
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
    return [_elections count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ElectionCell";
    FindElectionsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    Election *election = [_elections objectAtIndex:indexPath.row];

    cell.nameLabel.text = election.electionName;
    cell.dateStringLabel.text = [election getDateString];

    return cell;
}

@end
