

#import "YZJSEngineMethod.h"

typedef enum : NSUInteger {
    YZModuleMethodTypeSync,
    YZModuleMethodTypeAsync,
} YZModuleMethodType;

@interface YZModuleMethod : YZJSEngineMethod

@property (nonatomic, assign) YZModuleMethodType methodType;
@property (nonatomic, strong, readonly) NSString *moduleName;
@property (nonatomic, strong, readonly) NSDictionary *options;

- (instancetype)initWithModuleName:(NSString *)moduleName
                        methodName:(NSString *)methodName
                         arguments:(NSArray *)arguments
                           options:(NSDictionary *)options
                          instance:(YZSDKInstance *)instance;

- (NSInvocation *)invoke;

@end
