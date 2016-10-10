//
//  NilSafetyTests.m
//  NilSafetyTests
//
//  Created by Oborn.Jung on 16/10/9.
//  Copyright © 2016年 atg. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NilSafetyManager.h"

@interface NilSafetyTests : XCTestCase

@end

@implementation NilSafetyTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

//
// NSArray nil safe test case
- (void)test00_NSArray {
    
    NSObject * nilObj = nil;
    NSArray * testArray = nil;
    //
    // init nil object safeguard test
    [[NilSafetyManager sharedInstance] setupWithOdds:0.0f];
    XCTAssertThrows((testArray = @[@"1", @"2", @"3", nilObj]));
    [[NilSafetyManager sharedInstance] setupWithOdds:1.0f];
    XCTAssertNoThrow((testArray = @[@"1", @"2", @"3", nilObj]));
    //
    // objectAtIndex: safeguard logic test
    NSInteger count = testArray.count;
    [[NilSafetyManager sharedInstance] setupWithOdds:0.0f];
    XCTAssertThrows(testArray[count]);
    XCTAssert([testArray[0] isEqualToString:@"1"]);
    XCTAssert([testArray[2] isEqualToString:@"3"]);
    [[NilSafetyManager sharedInstance] setupWithOdds:1.0f];
    XCTAssertNoThrow(testArray[count]);
    XCTAssert([testArray[0] isEqualToString:@"1"]);
    XCTAssert([testArray[2] isEqualToString:@"3"]);
}

//
// NSMutableArray nil safe test case
- (void)test01_NSMutableArray {
    NSObject * nilObj = nil;
    NSMutableArray * testArray = nil;
    NSArray * verifyArray = @[@"1", @"2", @"3"];
    //
    // step1.init nil object safeguard test
    [[NilSafetyManager sharedInstance] setupWithOdds:0.0f];
    XCTAssertThrows((testArray = [@[@"1", @"2", @"3", nilObj] mutableCopy]));
    [[NilSafetyManager sharedInstance] setupWithOdds:1.0f];
    XCTAssertNoThrow((testArray = [@[@"1", @"2", @"3", nilObj] mutableCopy]));
    //
    // step2.objectAtIndex: safeguard logic test
    NSInteger count = testArray.count;
    [[NilSafetyManager sharedInstance] setupWithOdds:0.0f];
    XCTAssertThrows(testArray[count]);
    XCTAssert([testArray[0] isEqualToString:@"1"]);
    XCTAssert([testArray[2] isEqualToString:@"3"]);
    [[NilSafetyManager sharedInstance] setupWithOdds:1.0f];
    XCTAssertNoThrow(testArray[count]);
    XCTAssert([testArray[0] isEqualToString:@"1"]);
    XCTAssert([testArray[2] isEqualToString:@"3"]);
    //
    // step3.setObject:atIndexedSubscript: safeguard test
    [[NilSafetyManager sharedInstance] setupWithOdds:0.0f];
    XCTAssertThrows(testArray[1] = nilObj);
    testArray[0] = @"一";
    XCTAssert([testArray[0] isEqualToString:@"一"]);
    [[NilSafetyManager sharedInstance] setupWithOdds:1.0f];
    XCTAssertNoThrow(testArray[0] = nilObj);
    testArray[0] = @"1";
    XCTAssert([testArray[0] isEqualToString:@"1"]);
    
    //
    // step4.insertObject:atIndex: safeguard test
    [[NilSafetyManager sharedInstance] setupWithOdds:0.0f];
    XCTAssertThrows([testArray insertObject:nilObj atIndex:1]);
    [testArray insertObject:@"二" atIndex:1];
    XCTAssert([testArray[1] isEqualToString:@"二"]);
    [[NilSafetyManager sharedInstance] setupWithOdds:1.0f];
    XCTAssertNoThrow([testArray insertObject:nilObj atIndex:1]);
    [testArray insertObject:@"two" atIndex:1];
    XCTAssert([testArray[1] isEqualToString:@"two"]);
    //
    // step5.removeObjectAtIndex: safeguard test
    count = testArray.count;
    [[NilSafetyManager sharedInstance] setupWithOdds:0.0f];
    XCTAssertThrows([testArray removeObjectAtIndex:count]);
    [testArray removeObjectAtIndex:1];
    XCTAssert([testArray[1] isEqualToString:@"二"]);
    [[NilSafetyManager sharedInstance] setupWithOdds:1.0f];
    XCTAssertNoThrow([testArray removeObjectAtIndex:count]);
    [testArray removeObjectAtIndex:1];
    XCTAssert([testArray[1] isEqualToString:@"2"]);
    //
    // step6.insertObject:atIndex: safeguard test
    [[NilSafetyManager sharedInstance] setupWithOdds:0.0f];
    XCTAssertThrows([testArray replaceObjectAtIndex:0 withObject:nilObj]);
    [testArray replaceObjectAtIndex:1 withObject:@"二"];
    XCTAssert([testArray[1] isEqualToString:@"二"]);
    [[NilSafetyManager sharedInstance] setupWithOdds:1.0f];
    XCTAssertNoThrow([testArray replaceObjectAtIndex:0 withObject:nilObj]);
    [testArray replaceObjectAtIndex:1 withObject:@"2"];
    XCTAssert([testArray[1] isEqualToString:@"2"]);
    
    [verifyArray enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        XCTAssert([testArray[idx] isEqualToString:obj]);
    }];
}

//
// NSDictionary nil safe test case
- (void)test02_NSDictionary {
    
    NSNumber * nilKey = nil;
    NSString * nilValue = nil;
    NSDictionary * testDict = nil;
    
    //
    // init nil object safeguard test
    [[NilSafetyManager sharedInstance] setupWithOdds:0.0f];
    XCTAssertThrows((testDict = @{@"1":@"1", @"2":@"2", @"3":nilValue, nilKey:@"nil"}));
    [[NilSafetyManager sharedInstance] setupWithOdds:1.0f];
    XCTAssertNoThrow((testDict = @{@"1":@"1", @"2":@"2", @"3":nilValue, nilKey:@"nil"}));
    //
    // objectForKey: safeguard logic test
    [[NilSafetyManager sharedInstance] setupWithOdds:0.0f];
    XCTAssert([testDict[@"3"] isEqual:[NSNull null]]);
    XCTAssertNoThrow(testDict[nilKey]);
    XCTAssert([testDict[@"2"] isEqualToString:@"2"]);
    [[NilSafetyManager sharedInstance] setupWithOdds:1.0f];
    XCTAssert([testDict[@"3"] isEqual:[NSNull null]]);
    XCTAssertNoThrow(testDict[nilKey]);
    XCTAssert([testDict[@"1"] isEqualToString:@"1"]);
}

//
// NSMutableDictionary nil safe test case
- (void)test03_NSMutableDictionary {
    NSNumber * nilKey = nil;
    NSString * nilValue = nil;
    NSMutableDictionary * testDict = nil;
    //
    // step1.测试包含 nilKey 和 nilValue 情况
    [[NilSafetyManager sharedInstance] setupWithOdds:0.0f];
    XCTAssertThrows((testDict = [@{@"1":@"1", @"2":@"2", @"3":nilValue, nilKey:@"nil"} mutableCopy]));
    [[NilSafetyManager sharedInstance] setupWithOdds:1.0f];
    XCTAssertNoThrow((testDict = [@{@"1":@"1", @"2":@"2", @"3":nilValue, nilKey:@"nil"} mutableCopy]));
    //
    // step2.objectForKey: safeguard logic test
    [[NilSafetyManager sharedInstance] setupWithOdds:0.0f];
    XCTAssert([testDict[@"3"] isEqual:[NSNull null]]);
    XCTAssertNoThrow(testDict[nilKey]);
    XCTAssert([testDict[@"2"] isEqualToString:@"2"]);
    [[NilSafetyManager sharedInstance] setupWithOdds:1.0f];
    XCTAssert([testDict[@"3"] isEqual:[NSNull null]]);
    XCTAssertNoThrow(testDict[nilKey]);
    XCTAssert([testDict[@"1"] isEqualToString:@"1"]);
    //
    // step3.setObject:forKey: safeguard test
    [[NilSafetyManager sharedInstance] setupWithOdds:0.0f];
    XCTAssertThrows([testDict setObject:@"nil" forKey:nilKey]);
    XCTAssertThrows([testDict setObject:nilValue forKey:nilKey]);
    XCTAssertThrows([testDict setObject:nilValue forKey:@"1"]);
    XCTAssertNoThrow([testDict setObject:@"one" forKey:@"1"]);
    XCTAssert([testDict[@"1"] isEqualToString:@"one"]);
    
    [[NilSafetyManager sharedInstance] setupWithOdds:1.0f];
    XCTAssertNoThrow([testDict setObject:@"nil" forKey:nilKey]);
    XCTAssertNoThrow([testDict setObject:nilValue forKey:nilKey]);
    XCTAssertNoThrow([testDict setObject:nilValue forKey:@"1"]);
    XCTAssert([testDict[@"1"] isEqual:[NSNull null]]);
    XCTAssertNoThrow([testDict setObject:@"1" forKey:@"1"]);
    XCTAssert([testDict[@"1"] isEqualToString:@"1"]);
    //
    // step4.setObject:forKeyedSubscript: safeguard test
    [[NilSafetyManager sharedInstance] setupWithOdds:0.0f];
    XCTAssertThrows(testDict[nilKey] = @"nil");
    XCTAssertThrows(testDict[nilKey] = nilValue);
    XCTAssertNoThrow(testDict[@"1"] = nilValue);
    XCTAssert(testDict[@"1"] == nil);
    XCTAssertNoThrow(testDict[@"1"] = @"1");
    XCTAssert([testDict[@"1"] isEqualToString:@"1"]);
    
    [[NilSafetyManager sharedInstance] setupWithOdds:1.0f];
    XCTAssertNoThrow(testDict[nilKey] = @"nil");
    XCTAssertNoThrow(testDict[nilKey] = nilValue);
    XCTAssertNoThrow(testDict[@"1"] = nilValue);
    XCTAssert(testDict[@"1"] == nil);
    XCTAssertNoThrow(testDict[@"1"] = @"1");
    XCTAssert([testDict[@"1"] isEqualToString:@"1"]);
    //
    // step4.removeObjectForKey: safeguard test
    [[NilSafetyManager sharedInstance] setupWithOdds:0.0f];
    XCTAssertThrows([testDict removeObjectForKey:nilKey]);
    XCTAssertNoThrow([testDict removeObjectForKey:@"3"]);
    [[NilSafetyManager sharedInstance] setupWithOdds:1.0f];
    XCTAssertNoThrow([testDict removeObjectForKey:nilKey]);
    XCTAssertNoThrow([testDict removeObjectForKey:@"2"]);
    
    XCTAssert(testDict.count == 1 && [testDict[@"1"] isEqualToString:@"1"]);
}

@end
