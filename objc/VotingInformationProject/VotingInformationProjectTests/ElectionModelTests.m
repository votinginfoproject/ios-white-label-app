//
//  ElectionModelTests.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 1/21/14.
//  Copyright (c) 2014 Bennet Huber. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Election.h"

@interface ElectionModelTests : XCTestCase

@end

@implementation ElectionModelTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInitWithId
{
    Election *election1 = [[Election alloc] initWithId:@"testId"];
    XCTAssertNil(election1.name, @"election1.name should be nil");
    XCTAssertNil(election1.date, @"election1.date should be nil");
}

- (void)testInit
{
    Election *election1 = [[Election alloc] initWithId:@"testId"
                                               andName:@"TestName"
                                               andDate:@"2025-01-01"];
    XCTAssertEqual(election1.name, @"TestName", @"election1.name should have a value");
    XCTAssertEqual(election1.date, @"2025-01-01", @"election1.date should have a value");
}

- (void) testIsActive {
    Election *election1 = [[Election alloc] initWithId:@"testId"
                                               andName:@"TestName"
                                               andDate:@"2025-01-01"];
    XCTAssertTrue([election1 isActive], @"election1 isActive should be true if election1 in the future");

    Election *election2 = [[Election alloc] initWithId:@"testId"
                                               andName:@"TestName"
                                               andDate:@"1980-01-01"];
    XCTAssertFalse([election2 isActive], @"election2 isActive should be false if election2 in the past");
}

@end
