

#import "YZCallJSMethod.h"

@implementation YZCallJSMethod
{
    NSString *_moduleName;
}

- (instancetype)initWithModuleName:(NSString *)moduleName
                        methodName:(NSString *)methodName
                         arguments:(NSArray *)arguments
                          instance:(YZSDKInstance *)instance
{
    if (self = [super initWithMethodName:methodName arguments:arguments instance:instance]) {
        _moduleName = moduleName;
    }
    
    return self;
}

- (NSDictionary *)callJSTask
{
    return @{@"module":_moduleName ?: @"",
             @"method":self.methodName ?: @"",
             @"args":self.arguments ?: @[]};
}

@end
