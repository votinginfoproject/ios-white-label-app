//
//  DataSource.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 6/23/14.
//

#import "VIPModel.h"


@protocol DataSource
@end

@interface DataSource : VIPModel

@property (nonatomic, strong) NSString * name;
@property (nonatomic, assign) BOOL official;

@end
