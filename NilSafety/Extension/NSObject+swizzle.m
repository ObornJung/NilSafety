//
//  NSObject+swizzle.m
//  NilSafety
//
//  Created by Oborn.Jung on 16/10/10.
//  Copyright © 2016年 ATG. All rights reserved.
//

#import <objc/runtime.h>
#import "NSObject+swizzle.h"

@implementation NSObject (swizzle)

+ (BOOL)ns_swizzleMethod:(SEL)origSel withMethod:(SEL)altSel {
    
    Method origMethod = class_getInstanceMethod(self, origSel);
    Method altMethod = class_getInstanceMethod(self, altSel);
    if (!origMethod || !altMethod) {
        return NO;
    }
    class_addMethod(self,
                    origSel,
                    class_getMethodImplementation(self, origSel),
                    method_getTypeEncoding(origMethod));
    class_addMethod(self,
                    altSel,
                    class_getMethodImplementation(self, altSel),
                    method_getTypeEncoding(altMethod));
    method_exchangeImplementations(class_getInstanceMethod(self, origSel),
                                   class_getInstanceMethod(self, altSel));
    return YES;
}

+ (BOOL)ns_swizzleClassMethod:(SEL)origSel withMethod:(SEL)altSel {
    return [object_getClass((id)self) ns_swizzleMethod:origSel withMethod:altSel];
}

@end
