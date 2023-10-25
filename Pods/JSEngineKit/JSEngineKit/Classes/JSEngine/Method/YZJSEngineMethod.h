

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class YZSDKInstance;

@interface YZJSEngineMethod : NSObject

@property (nonatomic, strong, readonly) NSString *methodName;
@property (nonatomic, copy, readonly) NSArray *arguments;
@property (nonatomic, weak, readonly) YZSDKInstance *instance;

- (instancetype)initWithMethodName:(NSString *)methodName
                         arguments:(NSArray * _Nullable)arguments
                          instance:(YZSDKInstance *)instance;

- (NSInvocation *)invocationWithTarget:(id)target selector:(SEL)selector;

@end

NS_ASSUME_NONNULL_END
