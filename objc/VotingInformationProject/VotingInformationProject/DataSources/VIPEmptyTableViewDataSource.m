//
//  VIPEmptyTableViewDataSource.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 3/19/14.
//

#import "VIPEmptyTableViewDataSource.h"
#import "VIPEmptyCell.h"

@interface VIPEmptyTableViewDataSource()

@end

@implementation VIPEmptyTableViewDataSource

NSString * const VIP_EMPTY_TABLECELL_ID = @"VIPEmptyTableCell";

- (id) init
{
    return [self initWithEmptyMessage:NSLocalizedString(@"No Data Available",
                                                        @"The default text to display in an empty table cell if no data is available.")];
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
    VIPEmptyCell *cell = (VIPEmptyCell*)[tableView dequeueReusableCellWithIdentifier:VIP_EMPTY_TABLECELL_ID];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"VIPEmptyCell" bundle:nil] forCellReuseIdentifier:VIP_EMPTY_TABLECELL_ID];
        cell = (VIPEmptyCell*)[tableView dequeueReusableCellWithIdentifier:VIP_EMPTY_TABLECELL_ID];
    }
    cell.messageLabel.text = self.emptyMessage;
    return cell;
}

@end
