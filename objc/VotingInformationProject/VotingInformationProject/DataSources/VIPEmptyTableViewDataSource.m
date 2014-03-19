//
//  VIPEmptyTableViewDataSource.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 3/19/14.
//  Copyright (c) 2014 Bennet Huber. All rights reserved.
//

#import "VIPEmptyTableViewDataSource.h"

@interface VIPEmptyTableViewDataSource()

@property (strong, nonatomic) NSString *emptyMessage;

@end

@implementation VIPEmptyTableViewDataSource

NSString * const VIP_EMPTY_TABLECELL_ID = @"VIPEmptyTableCell";

- (id) init
{
    return [self initWithEmptyMessage:NSLocalizedString(@"No Data Available", nil)];
}

// Designated Initializer
- (instancetype) initWithEmptyMessage:(NSString *)message
{
    self = [super init];
    if (self) {
        self.emptyMessage = message;
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: Make custom cell via xib with single label and extra height
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:VIP_EMPTY_TABLECELL_ID forIndexPath:indexPath];
    cell.textLabel.text = self.emptyMessage;
    return cell;
}

@end
