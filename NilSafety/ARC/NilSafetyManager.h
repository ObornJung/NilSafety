//
//  NilSafetyManager.h
//  NilSafety
//
//  Created by Oborn.Jung on 16/9/1.
//  Copyright © 2016年 ATG. All rights reserved.
//

#import <CoreGraphics/CGBase.h>
#import <Foundation/Foundation.h>

@interface NilSafetyManager : NSObject

@property (nonatomic, assign, readonly) BOOL    nilSafeOn;  ///< nil safe switch
@property (nonatomic, assign, readonly) CGFloat odds;       ///< 开关打开概率[0.0f~1.0f]，默认0.0f

+ (instancetype)sharedInstance;

/**
 *    setup nilSafe Switch
 *
 *    @param odds 开关打开概率[0.0f~1.0f]
 */
- (void)setupWithOdds:(CGFloat)odds;

@end
