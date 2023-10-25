//
//  YZNativeMethodManager.h
//  JSEngineKit
//
//  Created by li on 2023/2/9.
//

#import <Foundation/Foundation.h>
#import "YZJSEngineContext.h"
NS_ASSUME_NONNULL_BEGIN

@interface YZNativeMethodManager : NSObject

+ (void)registerNativeFunctions:(YZJSEngineContext *)context provider:(NSDictionary *)providers;

@end

NS_ASSUME_NONNULL_END
