//
//  Election.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 1/20/14.
//  Copyright (c) 2014 Bennet Huber. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Election : NSObject

@property (nonatomic) NSString *electionId;
@property (nonatomic) NSString *name;
// TODO: Use NSDate to parse string of format YYYY-MM-DD
@property (nonatomic) NSString *date;

// designated initializer
- (id) initWithId: (NSString*) electionID
          andName: (NSString*) name
          andDate: (NSString*) date;

- (id) initWithId: (NSString*) electionID;

- (BOOL) isActive;

@end
