//
//  VIPEmptyTableViewDataSource.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 3/19/14.
//

#import <Foundation/Foundation.h>

// This empty table cell height should be set in the implementing
//  view controller's tableView:heightForRowAtIndexPath: method
//  if the source data is empty
#define VIP_EMPTY_TABLECELL_HEIGHT 88

/*
 * A dataSource object that can replace a regular dataSource in a UITableView
 * if there is no data. Example implementation in BallotViewController.h
 *
 * This class is designed to remove some of the messy if/else blocks that would occur
 * in a single section tableview in the DataSource methods. Unfortunately, you still get
 * the if/else blocks in the TableView delegate.
 *
 * Inspiration: http://blog.yangmeyer.de/blog/2013/05/11/best-practice-handling-empty-table-views
 *
 * TODO: Refactor so that the delegate can be abstracted here as well.
 */
@interface VIPEmptyTableViewDataSource : NSObject <UITableViewDataSource>

extern NSString * const VIP_EMPTY_TABLECELL_ID;

/*
 * Designated Initializer
 *
 * @param message The message to display in the table cell
 *                If -init is called instead of this, the default message
 *                is NSLocalizedString("No Data Available", nil)
 */
- (instancetype)initWithEmptyMessage:(NSString*)message;

/*
 * Sample configureDataSource method for use in a TableView controller
 * Right before calling [tableView reloadData] in your view controller, call
 * this method with:
 * self.tableView.dataSource = [self configureDataSource];
 *
 * Example in BallotViewController.m
 */
/*
- (id<UITableViewDataSource>)configureDataSource
{
    return ([self.tableData count] > 0) ? self : self.emptyDataSource;
}
*/

@end
