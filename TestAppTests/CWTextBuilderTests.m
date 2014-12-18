//
//  CWTextBuilderTests.m
//  TestApp
//
//  Created by Liliya Fedotova on 17.12.14.
//  Copyright (c) 2014 peekaboo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "CWTextBuilder.h"

@interface CWTextBuilderTests : XCTestCase

@end

@implementation CWTextBuilderTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testBuildList {
    // This is an example of a functional test case.
    NSError *error = nil;
    NSArray *jsonDictionary = @[@{ @"id": @"ID1",
                                   @"title": @"Juicy Apple",
                                   @"text": @"This is a rand..."} ,
                                @{ @"id": @"ID2",
                                   @"id": @"13",
                                   @"id": @"Time to die: 5s"}];
    NSArray *list = [CWTextBuilder listFromJSON:jsonDictionary error:&error oldList:nil];
    CWText *firstElement = [list firstObject];
    XCTAssertEqual([list count], 2, @"List must have 2 elements");
    XCTAssertEqual(firstElement.cwId, @"ID1", @"First element must be ID1");
}

@end
