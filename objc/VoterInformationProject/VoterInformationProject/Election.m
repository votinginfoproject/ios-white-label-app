//
//  Election.m
//  VoterInformationProject
//
//  Created by Andrew Fink on 1/20/14.
//  Copyright (c) 2014 Bennet Huber. All rights reserved.
//

#import "Election.h"

@implementation Election

- (id) initWithId:(NSString *)electionID {
    return [self initWithId:electionID
                    andName:@""
                    andDate:@"1970-01-01"];
}

- (id) initWithId:(NSString *)electionID andName:(NSString *)name andDate:(NSString *)date {
    self = [super init];
    if (self) {
        self.electionId = electionID;
        self.name = name;
        self.date = date;
    }
    return self;
}

- (BOOL) isInactive {
    // TODO: Implement
    return NO;
}

@end
