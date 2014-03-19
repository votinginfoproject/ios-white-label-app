//
//  VIPEmptyTableViewDataSource.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 3/19/14.
//  Copyright (c) 2014 Bennet Huber. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VIPEmptyTableViewDataSource : NSObject <UITableViewDataSource>

extern NSString * const VIP_EMPTY_TABLECELL_ID;

- (instancetype)initWithEmptyMessage:(NSString*)message;

@end
