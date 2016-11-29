//
//  NSArray+NilSafety.m
//  NilSafety
//
//  Created by Oborn.Jung on 16/9/1.
//  Copyright © 2016年 ATG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSObject+swizzle.h"
#import "NilSafetyManager.h"
#import "NSArray+NilSafety.h"
#import "NilSafety+Private.h"

@implementation NSArray (NilSafety)

+ (void)load {
    NIL_SAFETY_SW();
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class clsI = NSClassFromString(@"__NSArrayI");
        [clsI sm_swizzleMethod:@selector(objectAtIndex:)
                    withMethod:@selector(ns_objectAtIndex:)];
        Class clsP = NSClassFromString(@"__NSPlaceholderArray");
        [clsP sm_swizzleMethod:@selector(initWithObjects:count:)
                    withMethod:@selector(ns_initWithObjects:count:)];
        [self sm_swizzleClassMethod:@selector(arrayWithObjects:count:)
                         withMethod:@selector(ns_arrayWithObjects:count:)];
        
    });
}

+ (instancetype)ns_arrayWithObjects:(const id [])objects count:(NSUInteger)cnt {
    if ([NilSafetyManager sharedInstance].nilSafeOn) {
        id safeObjects[cnt];
        int safeCnt = 0;
        for (int i = 0; i < cnt; i ++) {
            id obj = objects[i];
            if (obj) {
                safeObjects[safeCnt] = obj;
                safeCnt ++;
            }
        }
        return [self ns_arrayWithObjects:safeObjects count:safeCnt];
    } else {
        return [self ns_arrayWithObjects:objects count:cnt];
    }
}

- (id)ns_objectAtIndex:(NSUInteger)index {
    if ([NilSafetyManager sharedInstance].nilSafeOn) {
        if (index >= self.count) {
            // nothing to do
            return nil;
        }
    }
    return [self ns_objectAtIndex:index];
}

- (instancetype)ns_initWithObjects:(const id [])objects count:(NSUInteger)cnt {
    if ([NilSafetyManager sharedInstance].nilSafeOn) {
        id safeObjects[cnt];
        int safeCnt = 0;
        for (int i = 0; i < cnt; i ++) {
            id obj = objects[i];
            if (obj) {
                safeObjects[safeCnt] = obj;
                safeCnt ++;
            }
        }
        return [self ns_initWithObjects:safeObjects count:safeCnt];
    } else {
        return [self ns_initWithObjects:objects count:cnt];
    }
}

@end

@implementation NSMutableArray (NilSafety)

+ (void)load {
    NIL_SAFETY_SW();
    static dispatch_once_t onceToken;
    [[NSUserDefaults standardUserDefaults] objectForKey:@""];
    dispatch_once(&onceToken, ^{
        Class arrayCls = NSClassFromString(@"__NSArrayM");
        [arrayCls sm_swizzleMethod:@selector(removeObjectAtIndex:)
                        withMethod:@selector(ns_removeObjectAtIndex:)];
        [arrayCls sm_swizzleMethod:@selector(insertObject:atIndex:)
                        withMethod:@selector(ns_insertObject:atIndex:)];
//        [arrayCls sm_swizzleMethod:@selector(setObject:atIndexedSubscript:)
//                        withMethod:@selector(ns_setObject:atIndexedSubscript:)];
        [arrayCls sm_swizzleMethod:@selector(replaceObjectAtIndex:withObject:)
                        withMethod:@selector(ns_replaceObjectAtIndex:withObject:)];
    });
}

- (void)ns_insertObject:(id)anObject atIndex:(NSUInteger)index {
    if ([NilSafetyManager sharedInstance].nilSafeOn) {
        if (!anObject || index > self.count) {
            // nothing to do
            return;
        }
    }
    [self ns_insertObject:anObject atIndex:index];
}

- (void)ns_setObject:(id)anObject atIndexedSubscript:(NSUInteger)index {
    if ([NilSafetyManager sharedInstance].nilSafeOn) {
        if (!anObject || (index >= self.count)) {
            // nothing to do
            return;
        }
    }
    [self ns_setObject:anObject atIndexedSubscript:index];
}

- (void)ns_replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {
    if ([NilSafetyManager sharedInstance].nilSafeOn) {
        if (!anObject || (index >= self.count)) {
            // nothing to do
            return;
        }
    }
    [self ns_replaceObjectAtIndex:index withObject:anObject];
}

- (void)ns_removeObjectAtIndex:(NSUInteger)index {
    if ([NilSafetyManager sharedInstance].nilSafeOn) {
        if (index >= self.count) {
            // nothing to do
            return;
        }
    }
    [self ns_removeObjectAtIndex:index];
}

@end
