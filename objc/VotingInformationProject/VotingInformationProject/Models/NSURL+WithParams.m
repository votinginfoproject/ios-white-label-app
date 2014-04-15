//
//  NSURL+WithParams.m
//
//  Created by Andrew Fink on 4/14/14.
//

#import "NSURL+WithParams.h"

@implementation NSURL (WithParams)

+ (NSURL*)URLFromString:(NSString *)urlString
             withParams:(NSDictionary *)params
{
    NSMutableArray *parts = [[NSMutableArray alloc] initWithCapacity:[params count]];
    for (id key in params) {
        id value = [params objectForKey:key];
        NSString *stringKey = [key description];
        NSString *stringValue = [value description];
        NSString *urlSafeKey = [stringKey stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *urlSafeValue = [stringValue stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *part = [NSString stringWithFormat:@"%@=%@", urlSafeKey, urlSafeValue];
        [parts addObject:part];
    }
    NSString *paramsString = [parts componentsJoinedByString:@"&"];
    NSString *url = [[[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                      stringByAppendingString:@"?"]
                      stringByAppendingString:paramsString];
    return [NSURL URLWithString:url];
}

@end
