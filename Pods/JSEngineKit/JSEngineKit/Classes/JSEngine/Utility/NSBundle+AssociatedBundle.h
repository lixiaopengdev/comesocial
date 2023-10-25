//
//  NSBundle.h
//  JSEngineKit
//
//  Created by li on 2023/1/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSBundle (AssociatedBundle)

+ (NSBundle *)bundleWithBundleName:(NSString *)bundleName podName:(NSString *)podName;
@end

NS_ASSUME_NONNULL_END
