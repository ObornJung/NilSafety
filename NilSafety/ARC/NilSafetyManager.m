//
//  NilSafetyManager.m
//  NilSafety
//
//  Created by Oborn.Jung on 16/9/1.
//  Copyright © 2016年 ATG. All rights reserved.
//

#import "NilSafetyManager.h"
#import "NilSafety+Private.h"

NSString * const kNilSafeSWKey = @"NilSafeSWKey";

@implementation NilSafetyManager

+ (instancetype)sharedInstance {
    static NilSafetyManager * sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (instancetype)init {
    if (self = [super init]) {
        [self setupWithOdds:0];
    }
    return self;
}

- (void)setupWithOdds:(CGFloat)odds {
    odds = odds < 0.0f ? 0.0f : odds;
    odds = odds > 1.0f ? 1.0f : odds;
    _odds = odds;
    if (ABS(odds) < FLT_EPSILON) {
        _nilSafeOn = NO;
    } else if (ABS(odds - 1.0f) < FLT_EPSILON) {
        _nilSafeOn = YES;
    } else {
        _nilSafeOn = arc4random_uniform(100) < odds * 100;
    }
    [[NSUserDefaults standardUserDefaults] setObject:@(_nilSafeOn) forKey:kNilSafeSWKey];
}

@end
