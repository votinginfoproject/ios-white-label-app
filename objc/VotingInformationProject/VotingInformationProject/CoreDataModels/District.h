//
//  District.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 6/23/14.
//

#import <Foundation/Foundation.h>
#import "VIPModel.h"


@interface District : VIPModel

@property (nonatomic, strong) NSString<Optional> * id;
@property (nonatomic, strong) NSString<Optional> * name;
@property (nonatomic, strong) NSString<Optional> * scope;

@end
