

#import "YZJSEngineMethod.h"

@interface YZCallJSMethod : YZJSEngineMethod

- (instancetype)initWithModuleName:(NSString *)moduleName
                        methodName:(NSString *)methodName
                         arguments:(NSArray *)arguments
                          instance:(YZSDKInstance *)instance;

- (NSDictionary *)callJSTask;

@end
