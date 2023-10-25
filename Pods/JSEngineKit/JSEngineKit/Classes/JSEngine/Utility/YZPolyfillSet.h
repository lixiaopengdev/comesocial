

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol YZPolyfillSetJSExports <JSExport>

+ (instancetype)create;

- (BOOL)has:(id)value;

- (NSUInteger)size;

- (void)add:(id)value;

- (BOOL)delete:(id)value;

- (void)clear;

@end

@interface YZPolyfillSet : NSObject <YZPolyfillSetJSExports>

@end

