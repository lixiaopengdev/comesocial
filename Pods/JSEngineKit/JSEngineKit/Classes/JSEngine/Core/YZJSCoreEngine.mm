
#import "YZJSCoreEngine.h"
#import "YZAssert.h"
#import <sys/utsname.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "JSValue+JS.h"
#import "YZJSEngineContext.h"
#import "YZPolyfillSet.h"
#import "JSContext+JS.h"
#import "YZUtility.h"
#import "NSBundle+AssociatedBundle.h"
#import <dlfcn.h>
#import "NSTimer+JS.h"
#import <mach/mach.h>

@interface YZJSCoreEngine ()
{
}

@property (nonatomic, strong)  JSContext *jsContext;
@property (nonatomic, copy)  NSString *instanceId;
@property (nonatomic, strong)  NSMutableDictionary *callbacks;
@property (nonatomic, strong) NSTimer *autoTimer;
@end

@implementation YZJSCoreEngine

- (instancetype)initWithInstanceId:(NSString *)instanceId
{
    if (self = [super init]) {
        _callbacks = [NSMutableDictionary new];
        _instanceId = instanceId;
        [self createDefaultContext];
    }
    return self;
}

- (void)dealloc
{
    _jsContext.instanceId = nil;
    _jsContext = nil; // Make sure that the context MUST be freed in JS thread.
}

- (JSContext *)javaScriptContext
{
    return _jsContext;
}

- (void)setinstanceId:(NSString *)instanceId
{
    _jsContext.instanceId = instanceId;
}

#pragma mark - YZJSEngineProtocol

- (void)executeJSFramework:(NSString *)frameworkScript
{
    YZAssertParam(frameworkScript);
    [_jsContext evaluateScript:frameworkScript withSourceURL:[NSURL URLWithString:@"js-main-jsfm.js"]];
}

- (JSValue *)callJSMethod:(NSString *)method args:(NSArray *)args
{
    NSLog(@"Calling JS... method:%@, args:%@", method, args);
    return [[_jsContext globalObject] invokeMethod:method withArguments:[args copy]];
}

-(void)registerHandler:(NSString *)eventName withBlock:(YZRegisterNativeMethodBlock)block {
    _jsContext[eventName] = block;
}

- (void)registerCallNative:(YZJSCallNative)callNative
{
    JSValue* (^callNativeBlock)(JSValue *, JSValue *, JSValue *) = ^JSValue*(JSValue *instance, JSValue *tasks, JSValue *callback){
        NSString *instanceId = [instance toString];
        NSArray *tasksArray = [tasks toArray];
        NSString *callbackId = [callback toString];
        NSLog(@"Calling native... instance:%@, tasks:%@, callback:%@", instanceId, tasksArray, callbackId);
        return [JSValue valueWithInt32:(int32_t)callNative(instanceId, tasksArray, callbackId) inContext:[JSContext currentContext]];
    };
    
    _jsContext[@"callNative"] = callNativeBlock;
}

- (void)executeJavascript:(NSString *)script
{
    YZAssertParam(script);
    [_jsContext evaluateScript:script];
}

- (JSValue*)executeJavascript:(NSString *)script withSourceURL:(NSURL*)sourceURL
{
    YZAssertParam(script);

    if (sourceURL) {
        return [_jsContext evaluateScript:script withSourceURL:sourceURL];
    } else {
        return [_jsContext evaluateScript:script];
    }
}


- (void)registerCallAddEvent:(YZJSCallAddEvent)callAddEvent
{
    id YZJSCallAddEventBlock = ^(JSValue *instanceId, JSValue *ref,JSValue *event, JSValue *ifCallback) {
        
        NSString *instanceIdString = [instanceId toString];
        NSString *refString = [ref toString];
        NSString *eventString = [event toString];
        
        NSLog(@"callAddEvent...%@, %@, %@", instanceIdString, refString, eventString);
        return [JSValue valueWithInt32:(int32_t)callAddEvent(instanceIdString, refString,eventString) inContext:[JSContext currentContext]];
    };
    
    _jsContext[@"callAddEvent"] = YZJSCallAddEventBlock;
}

- (void)registerCallRemoveEvent:(YZJSCallRemoveEvent)callRemoveEvent
{
    id YZJSCallRemoveEventBlock = ^(JSValue *instanceId, JSValue *ref,JSValue *event, JSValue *ifCallback) {
        
        NSString *instanceIdString = [instanceId toString];
        NSString *refString = [ref toString];
        NSString *eventString = [event toString];
        
        NSLog(@"callRemoveEvent...%@, %@, %@", instanceIdString, refString,eventString);
        return [JSValue valueWithInt32:(int32_t)callRemoveEvent(instanceIdString, refString,eventString) inContext:[JSContext currentContext]];
    };
    
    _jsContext[@"callRemoveEvent"] = YZJSCallRemoveEventBlock;
}

- (void)registerCallNativeModule:(YZJSCallNativeModule)callNativeModuleBlock
{
    _jsContext[@"callNativeModule"] = ^JSValue *(JSValue *instanceId, JSValue *moduleName, JSValue *methodName, JSValue *args, JSValue *options) {
        NSString *instanceIdString = [instanceId toString];
        NSString *moduleNameString = [moduleName toString];
        NSString *methodNameString = [methodName toString];
        NSArray *argsArray = [args toArray];
        NSDictionary *optionsDic = [options toDictionary];
        
        NSLog(@"callNativeModule...%@,%@,%@,%@", instanceIdString, moduleNameString, methodNameString, argsArray);
        
        NSInvocation *invocation = callNativeModuleBlock(instanceIdString, moduleNameString, methodNameString, argsArray, optionsDic);
        JSValue *returnValue = [JSValue yz_valueWithReturnValueFromInvocation:invocation inContext:[JSContext currentContext]];
        return returnValue;
    };
}


- (JSValue*)exception
{
    return _jsContext.exception;
}

- (void)resetEnvironment
{
    NSDictionary *data = @{};
    _jsContext[@"JSEnvironment"] = data;
}

- (JSValue *)getJsValueWithName:(id)name {
    return _jsContext[name];
}

#pragma mark - Private

- (void)createDefaultContext
{
    _jsContext = [[JSContext alloc] init];
    _jsContext.name = @"js Context";
    _jsContext.instanceId = _instanceId;
    JSWeakSelf
    _jsContext[@"setTimeout"] = ^(JSValue *function, JSValue *timeout) {
        JSStrongSelf
        [self performSelector:@selector(triggerTimeout:) withObject:^(){
            [function callWithArguments:@[]];
        } afterDelay:[timeout toDouble] / 1000];
    };
    
    _jsContext[@"setInterval_js"] = ^(JSValue *function, JSValue *arg){
        JSStrongSelf
        if (!self.autoTimer || ![self.autoTimer isValid]) {
            double num = arg.toDouble;
            self.autoTimer = [NSTimer js_scheduledTimerWithTimeInterval:num block:^{
                [function callWithArguments:@[]];
            } repeats:YES];
        }
    };
    _jsContext[@"stopInterval"] =^(JSValue *value) {
        JSStrongSelf
        if (self.autoTimer && [self.autoTimer isValid]) {
            [self.autoTimer invalidate];
            self.autoTimer = nil;
        }
    };
    
    [self mountContextEnvironment:_jsContext];

}

- (void)triggerTimeout:(void(^)(void))block
{
    block();
}

- (void)excutJsfiles:(NSString *)filePath {
    NSFileManager *myFileManager = [NSFileManager defaultManager];
    NSDirectoryEnumerator *myDirectoryEnumerator = [myFileManager enumeratorAtPath:filePath];
    BOOL isDir = NO;
    BOOL isExist = NO;
    for (NSString *path in myDirectoryEnumerator.allObjects) {
        NSLog(@"%@", path);  // 所有路径
        NSString *jsPath = [NSString stringWithFormat:@"%@/%@", filePath, path];
        isExist = [myFileManager fileExistsAtPath:jsPath isDirectory:&isDir];
            if (!isDir && [path hasSuffix:@".js"]) {
                NSLog(@"%@", path);
                NSString *script = [NSString stringWithContentsOfFile:jsPath encoding:NSUTF8StringEncoding error:nil];
                [self executeJavascript:script];
            }
    }
}

- (void)executejavaScriptFile {
    NSString *filePath = [NSBundle bundleWithBundleName:@"JSEngineKit" podName:@"JSEngineKit"].bundlePath;
    [self excutJsfiles:filePath];
}

- (void)mountContextEnvironment:(JSContext*)context
{
    NSDictionary *data = [YZUtility getEnvironment];
    context[@"YZEnvironment"] = data;
    
    context[@"btoa"] = ^(JSValue *value ) {
        NSData *nsdata = [[value toString]
                          dataUsingEncoding:NSISOLatin1StringEncoding];
        NSString *base64Encoded = [nsdata base64EncodedStringWithOptions:0];
        return base64Encoded;
    };
    context[@"atob"] = ^(JSValue *value ) {
        NSData *nsdataFromBase64String = [[NSData alloc]
                                          initWithBase64EncodedString:[value toString] options:0];
        NSString *base64Decoded = [[NSString alloc]
                                   initWithData:nsdataFromBase64String encoding:NSISOLatin1StringEncoding];
        return base64Decoded;
    };
    
    // Avoid exceptionHandler be recursively invoked and finally cause stack overflow.
    context.exceptionHandler = ^(JSContext *context, JSValue *exception){
        NSLog(@" debug ===== %@",exception);
    };
    
//    context[@"console"][@"error"] = ^(){
//    };
//    context[@"console"][@"warn"] = ^(){
//    };
//    context[@"console"][@"info"] = ^(){
//    };
//    context[@"console"][@"debug"] = ^(){
//    };
    context[@"console"][@"log"] = ^(){
        [self handleConsoleOutputWithArgument:[JSContext currentArguments]];
    };
    
    context[@"oc_log"] = ^(id data) {
        NSLog(@"js_log:%@", data);
    };
    
    context[@"extendCallNative"] = ^(JSValue *value ) {
         
    };
    [self executejavaScriptFile];
}

- (void)handleConsoleOutputWithArgument:(NSArray *)arguments
{
    NSMutableString *string = [NSMutableString string];
    [string appendString:@"jsLog: "];
    [arguments enumerateObjectsUsingBlock:^(JSValue *jsVal, NSUInteger idx, BOOL *stop) {
        [string appendFormat:@"%@ ", jsVal];
        if (idx == arguments.count - 1) {
            [string appendFormat:@"%@ ", jsVal];
            NSLog(@"%@", string);
            
        }
    }];
}

-(void)addInstance:(NSString *)instance callback:(NSString *)callback
{
    if(instance.length > 0){
        if([_callbacks objectForKey:instance]){
            NSMutableArray *arr = [_callbacks objectForKey:instance];
            if (callback.length>0 && ![arr containsObject:callback]) {
                [arr addObject:callback];
                [_callbacks setObject:arr forKey:instance];
            }
        }else {
            NSMutableArray *arr = [NSMutableArray new];
            if (callback.length>0 && ![arr containsObject:callback]) {
                [arr addObject:callback];
                [_callbacks setObject:arr forKey:instance];
            }
        }
    }
}

- (void)callBack:(NSDictionary *)dic
{
    if([dic objectForKey:@"ret"]) {
//        [[YZSDKManager bridgeMgr] callBack:[dic objectForKey:@"appId"] funcId:[dic objectForKey:@"ret"]  params:[dic objectForKey:@"arg"] keepAlive:NO];
    }

}
@end
