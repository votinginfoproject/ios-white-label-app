//
//  PollingPickerOption.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 10/27/14.
//

#import <Foundation/Foundation.h>

#import "PollingLocation+API.h"

@interface PollingPickerOption : NSObject

@property (assign, nonatomic) VIPPollingLocationType type;
@property (strong, nonatomic) NSString* desc;

// Designated Initializer
-(instancetype) initWithType:(VIPPollingLocationType)type andDescription:(NSString*)desc;

@end
