//
//  LCTFlightAttitudeTest.m
//  LeapControlTower
//
//  Created by Sihao Lu on 2/9/14.
//  Copyright (c) 2014 DJBen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LCTFlightAttitude.h"

#define E 1e-7

@interface LCTFlightAttitudeTest : XCTestCase

@end

@implementation LCTFlightAttitudeTest

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testZero
{
    LCTFlightAttitude *attitude = [LCTFlightAttitude zero];
    XCTAssertEqualWithAccuracy(attitude.pitch, 0, E, @"");
    XCTAssertEqualWithAccuracy(attitude.roll, 0, E, @"");
    XCTAssertEqualWithAccuracy(attitude.yaw, 0, E, @"");
}

- (void)testJson {
    LCTFlightAttitude *attitude = [[LCTFlightAttitude alloc] initWithPitch:1 roll:2 yaw:3];
    NSString *json = [attitude jsonString];
    NSError *error;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    NSLog(@"%@, %@", dict, error);
    XCTAssertNil(error, @"JSON serialization has error!");
}

@end
