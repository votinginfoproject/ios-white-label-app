//
//  NSURL+WithParams.h
//
//  Created by Andrew Fink on 4/14/14.
//

#import <Foundation/Foundation.h>

@interface NSURL (WithParams)

+ (NSURL*) URLFromString:(NSString*)urlString
              withParams:(NSDictionary*)params;

@end
