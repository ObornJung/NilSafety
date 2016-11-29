//
//  NilSafety+Private.h
//  NilSafety
//
//  Created by Oborn.Jung on 2016/11/29.
//  Copyright © 2016年 atg. All rights reserved.
//

#ifndef NilSafety_Private_h
#define NilSafety_Private_h

extern NSString * const kNilSafeSWKey;

#define NIL_SAFETY_SW() do {\
NSNumber * nilSafeSW = [[NSUserDefaults standardUserDefaults] objectForKey:kNilSafeSWKey];\
if (![nilSafeSW boolValue]) {\
    return;\
}\
}while(0)



#endif /* NilSafety_Private_h */
