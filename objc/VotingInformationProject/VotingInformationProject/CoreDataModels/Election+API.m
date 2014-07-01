//
//  Election+API.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 6/24/14.
//

#import "Election+API.h"
#import "AppSettings.h"
#import "AFNetworking/AFNetworking.h"
#import "VIPError.h"

@implementation Election (API)

- (NSString *) getDateString
{
    NSString *electionDateString = nil;
    if (self.date) {
        NSDateFormatter *yyyymmddFormatter = [[NSDateFormatter alloc] init];
        [yyyymmddFormatter setDateStyle:NSDateFormatterMediumStyle];
        [yyyymmddFormatter setTimeStyle:NSDateFormatterNoStyle];
        electionDateString = [yyyymmddFormatter stringFromDate:self.date];
    }
    return electionDateString;
}

- (void) setDateFromString:(NSString *)stringDate
{
    NSDateFormatter *yyyymmddFormatter = [Election getElectionDateFormatter];
    self.date = [yyyymmddFormatter dateFromString:stringDate];
}

+ (NSDateFormatter*)getElectionDateFormatter
{
    // setup date formatter
    static dispatch_once_t onceToken;
    static NSDateFormatter *yyyymmddFormatter = nil;
    dispatch_once(&onceToken, ^{
        yyyymmddFormatter = [[NSDateFormatter alloc] init];
        [yyyymmddFormatter setDateFormat:@"yyyy-MM-dd"];
    });
    return yyyymmddFormatter;
}

+ (NSDate*)today
{
    NSCalendarUnit units = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents* comps = [[NSCalendar currentCalendar] components:units fromDate:[NSDate date]];
    comps.day = comps.day - 1;
    return [[NSCalendar currentCalendar] dateFromComponents:comps];
}

+ (NSArray*)getFutureElections
{
    BOOL appDebug = [[[AppSettings settings] valueForKey:@"DEBUG"] boolValue];
    NSArray *allElections = nil;
    if (appDebug) {
        allElections = [Election MR_findAllSortedBy:@"date" ascending:YES];
    } else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(date >= %@)", [Election today]];
        NSArray *elections = [Election MR_findAllWithPredicate:predicate];
        NSSortDescriptor *dateDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"date"
                                                                         ascending:YES];
        NSSortDescriptor *idDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"electionId"
                                                                       ascending:YES];
        NSArray *descriptors = @[dateDescriptor, idDescriptor];
        allElections = [[elections filteredArrayUsingPredicate:predicate]
                        sortedArrayUsingDescriptors:descriptors];
    }

    // CoreData returns the sub-entities in this fetch as well, so remove them
    NSMutableArray *onlyElections = [[NSMutableArray alloc] initWithCapacity:[allElections count]];
    for (id election in allElections) {
        if ([election isMemberOfClass:[Election class]]) {
            [onlyElections addObject:election];
        }
    }
    return onlyElections;
}

+ (BOOL) isElectionDictValid:(NSDictionary*)election {
    if (!election[@"id"]) {
        return NO;
    }
    if (!election[@"name"]) {
        return NO;
    }

    NSDateFormatter *yyyymmddFormatter = [Election getElectionDateFormatter];
    NSDate *electionDate = [yyyymmddFormatter dateFromString:election[@"electionDay"]];
    if (!electionDate) {
        return NO;
    }
    return YES;
}

+ (Election*)getUnique:(NSString*)electionId
{
    Election *election = nil;
    if ([electionId length] > 0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"electionId == %@", electionId];
        election = [Election MR_findFirstWithPredicate:predicate];
        if (!election) {
            election = [Election MR_createEntity];
            election.electionId = electionId;
            election.electionName = nil;
            election.date = nil;
            NSManagedObjectContext *moc = [NSManagedObjectContext MR_defaultContext];
            [moc MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError* error) {
                if (success) {
                    NSLog(@"Election SAVED: %@", electionId);
                } else if (error) {
                    NSLog(@"Election ERROR: %@, %@", electionId, error);
                } else {
                    NSLog(@"Election: %@ no change", electionId);
                }
            }];
#if DEBUG
            NSLog(@"Created new election with id: %@", electionId);
#endif
        } else {
#if DEBUG
            NSLog(@"Retrieved election %@ from data store", electionId);
#endif
        }
    }
    return election;
}

+ (NSDictionary*)getElectionRequestParamsForUrl:(NSString*)requestUrl
{
    NSDictionary *requestParams = nil;
    NSString *googleCivicAPIUrl = [[AppSettings settings]
                                   objectForKey:@"GoogleCivicInfoElectionQueryURL"];
    if ([requestUrl isEqualToString:googleCivicAPIUrl]) {
        NSString *civicApiKeyPath = [[NSBundle mainBundle] pathForResource:@"CivicAPIKey"
                                                                    ofType:@"plist"];
        NSDictionary *civicApiKeyDict = [[NSDictionary alloc] initWithContentsOfFile:civicApiKeyPath];
        requestParams = @{@"key": [civicApiKeyDict valueForKey:@"GoogleCivicInfoAPIKey"]};
    }

    return requestParams;
}

+ (void)getElectionList:(void (^)(NSArray *, NSError *))resultsBlock
{
    // Setup request manager
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes
                                                         setByAddingObjectsFromSet:[NSSet setWithObject:@"text/plain"]];

    NSString *requestUrl = [[AppSettings settings] objectForKey:@"ElectionListURL"];
    NSLog(@"URL: %@", requestUrl);

    [manager GET:requestUrl
      parameters:[Election getElectionRequestParamsForUrl:requestUrl]
         success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
             
             // On Success
             NSArray *electionData = [responseObject objectForKey:@"elections"];
             if (!electionData) {
                 // table view will simply be empty
                 NSError *error = [VIPError errorWithCode:VIPError.NoValidElections];
                 resultsBlock(@[], error);
                 return;
             }

             // Loop elections and create CoreData objects
             for (NSDictionary *entry in electionData) {
                 if (![Election isElectionDictValid:entry]) {
                     continue;
                 }

                 NSString *electionId = entry[@"id"];
                 Election *election = [Election getUnique:electionId];
                 election.electionName = entry[@"name"];
                 [election setDateFromString:entry[@"electionDay"]];
             }

             NSManagedObjectContext *moc = [NSManagedObjectContext MR_defaultContext];
             [moc MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
                 NSArray *elections = nil;
                 elections = [Election getFutureElections];
                 resultsBlock(elections, error);
             }];

         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             resultsBlock(@[], error);
         }];
}

@end
