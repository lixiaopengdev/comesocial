 

#import "YZJSEngineContext.h"
#import "YZJSCoreEngine.h"
#import "YZModuleFactory.h"
#import "YZModuleProtocol.h"
#import "YZAssert.h"
#import "YZInvocationConfig.h"
#import "YZModuleMethod.h"
#import "YZCallJSMethod.h"
#import "JSContext+JS.h"
#import "YZUtility.h"
#import "YZJSMethodDefine.h"
@interface YZJSEngineContext ()

@property (nonatomic, strong) id<YZJSEngineProtocol> jsEngine;
//store the methods which will be executed from native to js
@property (nonatomic, strong) NSMutableDictionary   *sendQueue;
//the instance stack
@property (nonatomic, strong) NSMutableArray    *insStack;
//identify if the JSFramework has been loaded
@property (nonatomic) BOOL frameworkLoadFinished;
//store some methods temporarily before JSFramework is loaded
@property (nonatomic, strong) NSMutableArray *methodQueue;
@property (nonatomic, copy) NSString *instanceId;

@end

@implementation YZJSEngineContext
    
- (instancetype) init
{
    self = [super init];
    if (self) {
        _methodQueue = [NSMutableArray new];
        _frameworkLoadFinished = NO;
        
        [self executeJsFramework];
    }
    return self;
}

- (void)destroyContext:(NSString *)instanceId {
    
}

- (void)setInstanceId:(NSString *)instanceId {
    _instanceId = instanceId;
}

- (id<YZJSEngineProtocol>)jsEngine
{
    Class engineClass = [YZJSCoreEngine class];
    if (_jsEngine && [_jsEngine isKindOfClass:engineClass]) {
        return _jsEngine;
    }
    if (_jsEngine) {
        [_methodQueue removeAllObjects];
        _frameworkLoadFinished = NO;
    }
    _jsEngine = [[YZJSCoreEngine alloc] initWithInstanceId:self.instanceId];
    [self registerGlobalFunctions];
    return _jsEngine;
}


- (void)registerGlobalFunctions
{
    __weak typeof(self) weakSelf = self;
    [_jsEngine registerCallNative:^NSInteger(NSString *instance, NSArray *tasks, NSString *callback) {
        return [weakSelf invokeNative:instance tasks:tasks callback:callback];
    }];
    
    [_jsEngine registerCallNativeModule:^NSInvocation*(NSString *instanceId, NSString *moduleName, NSString *methodName, NSArray *arguments, NSDictionary *options) {
        NSMutableDictionary * newOptions = options ? [options mutableCopy] : [NSMutableDictionary new];
        NSMutableArray * newArguments = [arguments mutableCopy];
        
        YZModuleMethod *method = [[YZModuleMethod alloc] initWithModuleName:moduleName methodName:methodName arguments:[newArguments copy] options:[newOptions copy] instance:nil];
        return [method invoke];
    }];
    
}

- (NSMutableArray *)insStack
{
    if (_insStack) return _insStack;

    _insStack = [NSMutableArray array];
    
    return _insStack;
}

- (NSMutableDictionary *)sendQueue
{
    YZAssertEngineThread();
    
    if (_sendQueue) return _sendQueue;
    
    _sendQueue = [NSMutableDictionary dictionary];
    
    return _sendQueue;
}

#pragma mark JS engine Management

- (NSInteger)invokeNative:(NSString *)instanceId tasks:(NSArray *)tasks callback:(NSString __unused*)callback
{
    YZAssertEngineThread();
    
    if (!instanceId || !tasks) {
        return 0;
    }
        
    for (NSDictionary *task in tasks) {
        NSString *methodName = task[@"method"];
        NSArray *arguments = task[@"args"];
    
        NSString *moduleName = task[@"module"];
        NSDictionary *options = task[@"options"];
        YZModuleMethod *method = [[YZModuleMethod alloc] initWithModuleName:moduleName methodName:methodName arguments:arguments options:options instance:nil];
        [method invoke];
    }
    
    [self performSelector:@selector(_sendQueueLoop) withObject:nil];
    return 1;
}

- (void)updateState:(NSString *)instance data:(id)data
{
    YZAssertEngineThread();
    YZAssertParam(instance);
    
    //[self.jsEngine callJSMethod:@"updateState" args:@[instance, data]];
}

- (void)executeJsFramework
{
    if ([self.jsEngine exception]) {
        NSString *exception = [[self.jsEngine exception] toString];
        NSMutableString *errMsg = [NSMutableString stringWithFormat:@"[YZ_KEY_EXCEPTION_SDK_INIT_JSFM_INIT_FAILED] %@",exception];
        NSLog(@"%@",errMsg);
        
    } else {
        self.frameworkLoadFinished = YES;
        for (NSDictionary *method in _methodQueue) {
            [self callJSMethod:method[@"method"] args:method[@"args"]];
        }
        [_methodQueue removeAllObjects];
    };
}

- (void)executeJsMethod:(YZCallJSMethod *)method
{
    YZAssertEngineThread();
    
    if (!method.instance) {
        NSLog(@"Instance doesn't exist!");
        return;
    }
    
    NSMutableArray *sendQueue = self.sendQueue[method.instance.instanceId];
    if (!sendQueue) {
        NSLog(@"No send queue for instance:%@, may it has been destroyed so method:%@ is ignored", method.instance, method.methodName);
        return;
    }
    
    [sendQueue addObject:method];
    [self performSelector:@selector(_sendQueueLoop) withObject:nil];
}

- (void)callJSMethod:(NSString *)method args:(NSArray *)args completion:(void (^)(id data))completion
{
    if (self.frameworkLoadFinished) {
        NSLog(@"Calling JS... method:%@, args:%@", method, args);
        JSValue *value = [self.jsEngine callJSMethod:method args:args];
        if (completion) {
            completion(value);
        }
    } else {
        NSMutableArray *newArg = [NSMutableArray array];
        if (completion) {
            [newArg addObject:completion];
        }
        [_methodQueue addObject:@{@"method":method, @"args":[newArg copy]}];
    }
}

- (JSValue *)excuteJSMethodWithResult:(YZCallJSMethod *)method
{
    YZAssertEngineThread();
    return  [self.jsEngine callJSMethod:@"callJS" args:nil];
}

- (void)executeJsFile:(NSString *)script
{
    [self.jsEngine executeJavascript:script];
}

- (void)executeJsFiles:(NSString *)path {
    [self.jsEngine excutJsfiles:path];
}

- (void)getJsSettings:(NSString *)filePath completion:(void (^)(id))completion
{
//    [self excutJsfiles:filePath];
    NSString *script = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    [self.jsEngine executeJavascript:script withSourceURL:nil];
    [self callJSMethod:YZJsSettingsFucName args:nil completion:completion];
}

- (void)setJsSettings:(NSDictionary *)dict completion:(void (^)(id))completion
{
    NSString *jsonString = [YZUtility JSONString:dict];
    [self.jsEngine callJSMethod:YZJsSetParameterSetingsFucName args:@[jsonString]];
}

- (void)executeJsService:(NSString *)script withName:(NSString *)name
{
    if(self.frameworkLoadFinished) {
        YZAssert(script, @"param script required!");
        if ([self.jsEngine respondsToSelector:@selector(javaScriptContext)]) {
            NSDictionary* funcInfo = @{
                                       @"func":@"executeJsService",
                                       @"arg":name?:@"unsetScriptName"
                                       };
            self.jsEngine.javaScriptContext[@"yzExtFuncInfo"] = funcInfo;
        }
        [self.jsEngine executeJavascript:script];
        if ([self.jsEngine respondsToSelector:@selector(javaScriptContext)]) {
            self.jsEngine.javaScriptContext[@"yzExtFuncInfo"] = nil;
        }
        
        if ([self.jsEngine exception]) {
            NSString *exception = [[self.jsEngine exception] toString];
            NSMutableString *errMsg = [NSMutableString stringWithFormat:@"[KEY_EXCEPTION_INVOKE_JSSERVICE_EXECUTE] name:%@,arg:%@,exception :$@",name,exception];
            NSLog(@"%@",errMsg);
        }
    }else {
        
    }
}
    
- (void)registerModules:(NSDictionary *)modules
{
    YZAssertEngineThread();
    
    if(!modules) return;
    
    [self callJSMethod:@"registerModules" args:@[]];
}

- (void)registerHandler:(NSString *)eventName withBlock:(YZJSCallNativeBlock)block
{
    JSWeakSelf
    [self.jsEngine registerHandler:eventName withBlock:^id _Nullable(JSValue *data) {
        JSStrongSelf
        if (data) {
            NSDictionary *dict = [YZUtility parseValue:data];
            return block(self.instanceId ,eventName ,dict);
        }
        return nil;
    }];
}

- (void)callJSMethod:(NSString *)method args:(NSArray *)args
{
    if (self.frameworkLoadFinished) {
        [self.jsEngine callJSMethod:method args:nil];
    }
    else {
        [_methodQueue addObject:@{@"method":method, @"args":args}];
    }
}


#pragma mark Private Mehtods

- (void)_sendQueueLoop
{
    YZAssertEngineThread();
    
    BOOL hasTask = NO;
    NSMutableArray *tasks = [NSMutableArray array];
    NSString *execIns = nil;
	
	@synchronized(self) {
		for (NSString *instance in self.insStack) {
			NSMutableArray *sendQueue = self.sendQueue[instance];
			if(sendQueue.count > 0){
				hasTask = YES;
				for(YZCallJSMethod *method in sendQueue){
					[tasks addObject:[method callJSTask]];
				}
				[sendQueue removeAllObjects];
				execIns = instance;
				break;
			}
		}
	}
    
    if (hasTask) {
        [self performSelector:@selector(_sendQueueLoop) withObject:nil];
    }
}

@end
