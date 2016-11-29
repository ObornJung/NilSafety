//
//  NSNull+NilSafety.m
//  NilSafety
//
//  Created by Oborn.Jung on 16/9/1.
//  Reference by https://github.com/allenhsu/NSDictionary-NilSafe
//  Copyright © 2016年 ATG. All rights reserved.
//

#import "NSObject+swizzle.h"
#import "NilSafetyManager.h"
#import "NSNull+NilSafety.h"
#import "NilSafety+Private.h"

@implementation NSNull (NilSafety)

+ (void)load {
    NIL_SAFETY_SW();
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self sm_swizzleMethod:@selector(methodSignatureForSelector:)
                    withMethod:@selector(ns_methodSignatureForSelector:)];
        [self sm_swizzleMethod:@selector(forwardInvocation:)
                    withMethod:@selector(ns_forwardInvocation:)];
    });
}

- (NSMethodSignature *)ns_methodSignatureForSelector:(SEL)aSelector {
    if ([NilSafetyManager sharedInstance].nilSafeOn) {
        NSMethodSignature * sig = [self ns_methodSignatureForSelector:aSelector];
        if (sig) {
            return sig;
        }
        return [NSMethodSignature signatureWithObjCTypes:@encode(void)];
    } else {
        return [self ns_methodSignatureForSelector:aSelector];
    }
}

- (void)ns_forwardInvocation:(NSInvocation *)anInvocation {
    if ([NilSafetyManager sharedInstance].nilSafeOn) {
        NSUInteger returnLength = [[anInvocation methodSignature] methodReturnLength];
        if (!returnLength) {
            // nothing to do
            return;
        }
        
        // set return value to all zero bits
        char buffer[returnLength];
        memset(buffer, 0, returnLength);
        
        [anInvocation setReturnValue:buffer];
    } else {
        [self ns_forwardInvocation:anInvocation];
    }
}

@end
