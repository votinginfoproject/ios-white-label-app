//
//  DataSource+API.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/4/14.
//  Copyright (c) 2014 Bennet Huber. All rights reserved.
//

#import "DataSource.h"

@interface DataSource (API)

- (BOOL) deleteObject;

+ (DataSource*) getUnique:(NSString*)name;

@end
