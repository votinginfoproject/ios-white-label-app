//
//  VIPBallotDetailsSort.m
//  VotingInformationProject
//
//  Created by Tom Nelson on 4/28/16.
//  Copyright © 2016 The Pew Charitable Trusts. All rights reserved.
//

#import "VIPBallotDetailsSort.h"

@implementation VIPBallotDetailsSort

+(NSArray*)stateSortOrder
{
    static NSArray *stateSortOrder = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        stateSortOrder = @[
                           NSLocalizedString(@"Name", @"Label for election administration body's name"),
                           kAddress,
                           NSLocalizedString(@"Hours", @"Label for election administration body's hours of operation"),
                           NSLocalizedString(@"Election Info", @"Label for election adnimistration body's information link"),
                           NSLocalizedString(@"Election Registration", @"Label for election administration body's registration information link"),
                           NSLocalizedString(@"Election Registration Confirmation", @"Label for election administration body's registration confirmation link"),
                           NSLocalizedString(@"Absentee Info", @"Label for election administration body's absentee voting information link"),
                           NSLocalizedString(@"Election Rules", @"Label for election administration body's election rules link"),
                           NSLocalizedString(@"Ballot Info", @"Label for ballot information link"),
                           NSLocalizedString(@"Voter Services", @"Label for election administration body's voter services"),
                           NSLocalizedString(@"Voting Location Finder", @"Label for voting location finder information link"),
                           ];
    });
    
    return stateSortOrder;
}

+(NSArray*)localJurisdictionSortOrder
{
    static NSArray *localJurisdictionSortOrder = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        localJurisdictionSortOrder = @[
                                       NSLocalizedString(@"Name", @"Label for election administration body's name"),
                                       kAddress,
                                       NSLocalizedString(@"Hours", @"Label for election administration body's hours of operation"),
                                       NSLocalizedString(@"Election Info", @"Label for election adnimistration body's information link"),
                                       NSLocalizedString(@"Election Registration", @"Label for election administration body's registration information link"),
                                       NSLocalizedString(@"Election Registration Confirmation", @"Label for election administration body's registration confirmation link"),
                                       NSLocalizedString(@"Absentee Info", @"Label for election administration body's absentee voting information link"),
                                       NSLocalizedString(@"Election Rules", @"Label for election administration body's election rules link"),
                                       NSLocalizedString(@"Voter Services", @"Label for election administration body's voter services"),
                                       NSLocalizedString(@"Voting Location Finder", @"Label for voting location finder information link"),
                                       NSLocalizedString(@"Ballot Info", @"Label for ballot information link"),
                                       ];
    });
    
    return localJurisdictionSortOrder;
}

+(NSDictionary*)returnItemMatchingElement:(NSString*)key fromArray:(NSArray*)unsortedList
{
    for (NSDictionary* item in unsortedList) {
        if (item[@"title"] == key) { return item; }
    }
    
    return nil;
}

+(NSMutableArray*)sortedStateList:(NSArray*)stateList
{
    NSMutableArray* sorted = [[NSMutableArray alloc] init];
    
    for (NSString* name in VIPBallotDetailsSort.stateSortOrder) {
        NSDictionary* item = [VIPBallotDetailsSort returnItemMatchingElement:name fromArray:stateList];
        
        if ([name isEqual: kAddress]) { item = [VIPBallotDetailsSort swapKeys:item]; }
        
        if (item != nil) { [sorted addObject:item]; }
    }
    
    return sorted;
}

+(NSMutableArray*)sortedLocalJurisdictionList:(NSArray*)localJurisdictionList
{
    NSMutableArray* sorted = [[NSMutableArray alloc] init];
    
    for (NSString* name in VIPBallotDetailsSort.localJurisdictionSortOrder) {
        NSDictionary* item = [VIPBallotDetailsSort returnItemMatchingElement:name fromArray:localJurisdictionList];
        
        if ([name isEqual: kAddress]) { item = [VIPBallotDetailsSort swapKeys:item]; }
        
        if (item != nil) { [sorted addObject:item]; }
    }
    
    return sorted;
}

+(NSDictionary*)swapKeys:(NSDictionary*)item
{
    if (item == nil) { return nil; }
    
    NSDictionary* address = [[NSDictionary alloc] initWithObjectsAndKeys:item[@"data"], @"title", @"", @"data", nil];
    
    return address;
}

@end
