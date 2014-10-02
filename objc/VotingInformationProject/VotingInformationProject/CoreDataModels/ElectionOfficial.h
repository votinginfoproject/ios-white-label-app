//
//  ElectionOfficial.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 6/23/14.
//

#import <Foundation/Foundation.h>
#import "VIPModel.h"

@protocol ElectionOfficial
@end

@interface ElectionOfficial : VIPModel

@property (nonatomic, strong) NSString<Optional> * name;
@property (nonatomic, strong) NSString<Optional> * title;
@property (nonatomic, strong) NSString<Optional> * officePhoneNumber;
@property (nonatomic, strong) NSString<Optional> * emailAddress;
@property (nonatomic, strong) NSString<Optional> * faxNumber;

@end
