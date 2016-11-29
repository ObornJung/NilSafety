//
//  NSDictionary+NilSafety.m
//  NilSafety
//
//  Created by Oborn.Jung on 16/9/1.
//  Reference by https://github.com/allenhsu/NSDictionary-NilSafe
//  Copyright © 2016年 ATG. All rights reserved.
//

#import "NSObject+swizzle.h"
#import "NilSafetyManager.h"
#import "NSDictionary+NilSafety.h"
#import "NilSafety+Private.h"

@implementation NSDictionary (NilSafety)

+ (void)load {
    NIL_SAFETY_SW();
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class cls = NSClassFromString(@"__NSPlaceholderDictionary");
        [cls sm_swizzleMethod:@selector(initWithObjects:forKeys:count:)
                   withMethod:@selector(ns_initWithObjects:forKeys:count:)];
        [self sm_swizzleClassMethod:@selector(dictionaryWithObjects:forKeys:count:)
                         withMethod:@selector(ns_dictionaryWithObjects:forKeys:count:)];
    });
}

+ (instancetype)ns_dictionaryWithObjects:(const id [])objects forKeys:(const id<NSCopying> [])keys count:(NSUInteger)cnt {
    if ([NilSafetyManager sharedInstance].nilSafeOn) {
        id safeObjects[cnt];
        id safeKeys[cnt];
        NSUInteger safeCnt = 0;
        for (NSUInteger i = 0; i < cnt; i ++) {
            id key = keys[i];
            id obj = objects[i];
            if (!key) {
                // nothing to do
                continue;
            }
            if (!obj) {
                obj = [NSNull null];
            }
            safeKeys[safeCnt]    = key;
            safeObjects[safeCnt] = obj;
            safeCnt ++;
        }
        return [self ns_dictionaryWithObjects:safeObjects forKeys:safeKeys count:safeCnt];
    } else {
        return [self ns_dictionaryWithObjects:objects forKeys:keys count:cnt];
    }
}

- (instancetype)ns_initWithObjects:(const id [])objects forKeys:(const id<NSCopying> [])keys count:(NSUInteger)cnt {
    if ([NilSafetyManager sharedInstance].nilSafeOn) {
        id safeObjects[cnt];
        id safeKeys[cnt];
        NSUInteger safeCnt = 0;
        for (NSUInteger i = 0; i < cnt; i++) {
            id key = keys[i];
            id obj = objects[i];
            if (!key) {
                // nothing to do
                continue;
            }
            if (!obj) {
                obj = [NSNull null];
            }
            safeKeys[safeCnt] = key;
            safeObjects[safeCnt] = obj;
            safeCnt++;
        }
        return [self ns_initWithObjects:safeObjects forKeys:safeKeys count:safeCnt];
    } else {
        return [self ns_initWithObjects:objects forKeys:keys count:cnt];
    }
}

@end

@implementation NSMutableDictionary (NilSafe)

+ (void)load {
    NIL_SAFETY_SW();
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = NSClassFromString(@"__NSDictionaryM");
        [class sm_swizzleMethod:@selector(setObject:forKey:)
                     withMethod:@selector(ns_setObject:forKey:)];
        [class sm_swizzleMethod:@selector(removeObjectForKey:)
                     withMethod:@selector(ns_removeObjectForKey:)];
        [class sm_swizzleMethod:@selector(setObject:forKeyedSubscript:)
                     withMethod:@selector(ns_setObject:forKeyedSubscript:)];
    });
}

- (void)ns_setObject:(id)anObject forKey:(id<NSCopying>)aKey {
    if ([NilSafetyManager sharedInstance].nilSafeOn) {
        if (!aKey) {
            // nothing to do
            return;
        }
        if (!anObject) {
            anObject = [NSNull null];
        }
    }
    
    [self ns_setObject:anObject forKey:aKey];
}

- (void)ns_setObject:(id)anObject forKeyedSubscript:(id<NSCopying>)aKey {
    if ([NilSafetyManager sharedInstance].nilSafeOn) {
        if (!aKey) {
            // nothing to do
            return;
        }
    }
    [self ns_setObject:anObject forKeyedSubscript:aKey];
}

- (void)ns_removeObjectForKey:(id)aKey {
    if ([NilSafetyManager sharedInstance].nilSafeOn) {
        if (!aKey) {
            // nothing to do
            return;
        }
    }
    [self ns_removeObjectForKey:aKey];
}

@end
