//
//  ElectionOfficial.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 6/23/14.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ElectionAdministrationBody;

@interface ElectionOfficial : VIPManagedObject

@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * faxNumber;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * officePhoneNumber;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) ElectionAdministrationBody *electionAdministrationBody;

@end
