//
//  Election.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 6/24/14.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Election : VIPManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * electionName;
@property (nonatomic, retain) NSString * electionId;

@end
