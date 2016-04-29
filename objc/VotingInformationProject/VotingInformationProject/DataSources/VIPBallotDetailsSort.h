//
//  VIPBallotDetailsSort.h
//  VotingInformationProject
//
//  Created by Tom Nelson on 4/28/16.
//  Copyright © 2016 The Pew Charitable Trusts. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VIPBallotDetailsSort : NSObject

#define kAddress @"Address" // This is an internal key, it should not be localized

+(NSArray*)stateSortOrder;
+(NSArray*)localJurisdictionSortOrder;

+(NSDictionary*)returnItemMatchingElement:(NSString*)key fromArray:(NSArray*)unsortedList;

+(NSMutableArray*)sortedStateList:(NSArray*)stateList;
+(NSMutableArray*)sortedLocalJurisdictionList:(NSArray*)localJurisdictionList;

@end
