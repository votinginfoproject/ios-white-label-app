//
//  JSONValueTransformer+NSDate.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 10/7/14.
//

#import "JSONValueTransformer.h"

@interface JSONValueTransformer (NSDate)

- (id)NSDateFromNSString:(NSString*)string;
- (id)JSONObjectFromNSDate:(NSDate*)tags;

@end
