//
//  ContactsSearchViewControllerDelegate.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 5/9/14.
//

#import <Foundation/Foundation.h>

#import "Election.h"

@class ContactsSearchViewController;

@protocol ContactsSearchViewControllerDelegate <NSObject>

- (void)contactsSearchViewControllerDidClose:(ContactsSearchViewController*)controller
                               withElections:(NSArray*)elections
                             currentElection:(Election*)election
                                    andParty:(NSString*)party;

@end

