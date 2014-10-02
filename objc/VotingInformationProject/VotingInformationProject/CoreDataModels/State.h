//
//  State.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 7/11/14.
//

#import <Foundation/Foundation.h>
#import "VIPModel.h"

#import "DataSource.h"
#import "ElectionAdministrationBody.h"

@protocol State
@end

@interface State : VIPModel

@property (nonatomic, strong) NSString<Optional> * name;
@property (nonatomic, strong) NSArray<DataSource, Optional> *dataSources;
@property (nonatomic, strong) ElectionAdministrationBody<Optional> *electionAdministrationBody;
@property (nonatomic, strong) State<Optional> *localJurisdiction;
@end
