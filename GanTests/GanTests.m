//
//  GanTests.m
//  GanTests
//
//  Created by sjpsega on 2016/10/24.
//  Copyright © 2016年 sjp. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface GanTests : XCTestCase

@end

@implementation GanTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    XCTAssert(1 > 0,@"pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end