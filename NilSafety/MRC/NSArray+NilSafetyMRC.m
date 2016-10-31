//
//  NSArray+NilSafetyMRC.m
//  NilSafety
//
//  Created by Oborn.Jung on 2016/10/28.
//  Copyright © 2016年 atg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSObject+swizzle.h"
#import "NilSafetyManager.h"
#import "NSArray+NilSafety.h"

@implementation NSMutableArray (NilSafetyMRC)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class arrayCls = NSClassFromString(@"__NSArrayM");
        [arrayCls sm_swizzleMethod:@selector(objectAtIndex:)
                        withMethod:@selector(ns_objectAtIndex:)];
    });
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

@end
