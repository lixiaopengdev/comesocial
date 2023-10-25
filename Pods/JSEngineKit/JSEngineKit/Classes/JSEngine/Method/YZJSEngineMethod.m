

#import "YZJSEngineMethod.h"
#import "YZSDKInstance.h"
#import "YZAssert.h"
#import <objc/runtime.h>
#import "YZJSEngineManager.h"
@implementation YZJSEngineMethod

- (instancetype)initWithMethodName:(NSString *)methodName arguments:(NSArray *)arguments instance:(YZSDKInstance *)instance
{
    if (self = [super init]) {
        _methodName = methodName;
        _arguments = arguments ? [arguments copy] : @[];
        _instance = instance;
    }
    
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p; instance = %@; method = %@; arguments= %@>", NSStringFromClass([self class]), self, _instance.instanceId, _methodName, _arguments];
}

-(id)parseArgument:(id)obj parameterType:(const char *)parameterType order:(int)order
{
#ifdef DEBUG
    BOOL check = YES;
#endif
    if (strcmp(parameterType,@encode(float))==0 || strcmp(parameterType,@encode(double))==0)
    {
#ifdef DEBUG
        check =  [obj isKindOfClass:[NSNumber class]];
        if(!check){
            NSLog(@"<%@: %p; instance = %@; method = %@; arguments= %@; the number %d parameter type is not right,it should be float or double>",NSStringFromClass([self class]), self, _instance.instanceId, _methodName, _arguments,order);
        }
#endif
        return [NSNumber numberWithDouble:[obj doubleValue]];
    } else if (strcmp(parameterType,@encode(int))==0) {
#ifdef DEBUG
        check =  [obj isKindOfClass:[NSNumber class]];
        if(!check){
            NSLog(@"<%@: %p; instance = %@; method = %@; arguments= %@; the number %d parameter type is not right,it should be int>",NSStringFromClass([self class]), self, _instance.instanceId, _methodName, _arguments,order);
        }
#endif
        return [NSNumber numberWithInteger:[obj integerValue]];
    } else if(strcmp(parameterType,@encode(id))==0) {
#ifdef DEBUG
        check =  [obj isKindOfClass:[NSArray class]] || [obj isKindOfClass:[NSDictionary class]] ||[obj isKindOfClass:[NSString class]];
        if(!check){
            NSLog(@"<%@: %p; instance = %@; method = %@; arguments= %@ ;the number %d parameter type is not right,it should be array ,map or string>",NSStringFromClass([self class]), self, _instance.instanceId, _methodName, _arguments,order);
        }
#endif
        return obj;
    } else if(strcmp(parameterType,@encode(typeof(^{})))==0) {
#ifdef DEBUG
        check =  [obj isKindOfClass:[NSString class]]; // jsfm pass string if parameter type is block
        if(!check){
            NSLog(@"<%@: %p; instance = %@; method = %@; arguments= %@; the number %d parameter type is not right,it should be block>",NSStringFromClass([self class]), self, _instance.instanceId, _methodName, _arguments,order);
        }
#endif
        return obj;
    }
    return obj;
}

- (NSInvocation *)invocationWithTarget:(id)target selector:(SEL)selector
{
    YZAssert(target, @"No target for method:%@", self);
    YZAssert(selector, @"No selector for method:%@", self);
    
    NSMethodSignature *signature = [target methodSignatureForSelector:selector];
    if (!signature) {
        NSString *errorMessage = [NSString stringWithFormat:@"target:%@, selector:%@ doesn't have a method signature", target, NSStringFromSelector(selector)];
        NSLog(@"%@",errorMessage);
        return nil;
    }
    
    NSUInteger redundantArgumentCount = 0;
    NSArray *arguments = _arguments;
    if (signature.numberOfArguments - 2 < arguments.count) {
        redundantArgumentCount = arguments.count - (signature.numberOfArguments - 2); // JS provides more arguments than required.
    }
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = target;
    invocation.selector = selector;
    void **freeList = NULL;
    
    NSMutableArray *blockArray = [NSMutableArray array];
    YZ_ALLOC_FLIST(freeList, arguments.count - redundantArgumentCount);
    for (int i = 0; i < arguments.count - redundantArgumentCount; i ++ ) {
        id obj = arguments[i];
        const char *parameterType = [signature getArgumentTypeAtIndex:i + 2];
        obj = [self parseArgument:obj parameterType:parameterType order:i];
        static const char *blockType = @encode(typeof(^{}));
        id argument;
        if (!strcmp(parameterType, blockType)) {
            // callback
            argument = [^void(id result, BOOL keepAlive) {
//                [[YZJSEngineManager sharedManager] callBack:instanceId funcId:(NSString *)obj params:nil keepAlive:keepAlive];
            } copy];
            
            // retain block
            [blockArray addObject:argument];
            [invocation setArgument:&argument atIndex:i + 2];
        } else {
            argument = obj;
            YZ_ARGUMENTS_SET(invocation, signature, i, argument, freeList);
        }
    }
    [invocation retainArguments];
    YZ_FREE_FLIST(freeList, arguments.count - redundantArgumentCount);
    
    return invocation;
}

@end
