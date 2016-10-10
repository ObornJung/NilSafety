//
//  NSObject+swizzle.h
//  NilSafety
//
//  Created by Oborn.Jung on 16/10/10.
//  Copyright © 2016年 ATG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (swizzle)

+ (BOOL)ns_swizzleMethod:(SEL)origSel withMethod:(SEL)altSel;

+ (BOOL)ns_swizzleClassMethod:(SEL)origSel withMethod:(SEL)altSel;

@end
