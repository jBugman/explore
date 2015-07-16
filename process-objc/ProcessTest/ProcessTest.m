#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
#import "process.h"

@interface ProcessTest : XCTestCase

@end

@implementation ProcessTest

- (void)testWorks {
    int result = process(@"Name", @"../test_data/");
    XCTAssert(result == EXIT_SUCCESS, @"It works");
}

@end
