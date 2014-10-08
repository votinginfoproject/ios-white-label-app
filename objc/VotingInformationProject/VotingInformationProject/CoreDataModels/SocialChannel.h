//
//  SocialChannel.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 6/23/14.
//

#import <Foundation/Foundation.h>
#import "VIPModel.h"

@protocol SocialChannel
@end

@interface SocialChannel : VIPModel

@property (nonatomic, strong) NSString * id;
@property (nonatomic, strong) NSString * type;

@end
