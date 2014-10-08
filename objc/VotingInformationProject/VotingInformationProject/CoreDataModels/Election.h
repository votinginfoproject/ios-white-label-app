//
//  Election.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 6/24/14.
//

#import <Foundation/Foundation.h>
#import "VIPModel.h"

@protocol Election
@end

@interface Election : VIPModel

@property (nonatomic, strong) NSString * id;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSDate * electionDay;

@end
