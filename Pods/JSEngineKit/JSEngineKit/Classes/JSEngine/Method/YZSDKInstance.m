

#import "YZSDKInstance.h"
#import "YZModuleFactory.h"
#import "YZAssert.h"
#import "YZThreadSafeMutableDictionary.h"
#import "YZJSCoreEngine.h"
#import "YZModuleMethod.h"

@implementation YZSDKInstance
{
    id _jsData;
    
    YZThreadSafeMutableDictionary *_moduleEventObservers;
    YZThreadSafeMutableDictionary *_moduleInstances;
    id<YZJSEngineProtocol> _instanceJavaScriptContext; // sandbox javaScript context
}

- (void)dealloc
{
    [_moduleEventObservers removeAllObjects];
    [self removeObservers];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _appearState = YES;
        NSInteger instanceId = 0;
        
        static NSInteger __instance = 0;
        instanceId = __instance % (1024*1024);
        __instance += 2; // always add by 2 as even number
        
        
        _instanceId = [NSString stringWithFormat:@"%ld", (long)instanceId];
        
        _bizType = @"";
        _pageName = @"";
        
        _moduleEventObservers = [YZThreadSafeMutableDictionary new];
        
        [self addObservers];
    }
    return self;
}

#pragma mark Public Mehtods

- (id)moduleForClass:(Class)moduleClass
{
    return nil;
}


- (void)fireGlobalEvent:(NSString *)eventName params:(NSDictionary *)params
{
    if (!params){
        params = [NSDictionary dictionary];
    }
    NSDictionary * userInfo = @{
            @"instanceId":self.instanceId,
            @"param":params
    };
    [[NSNotificationCenter defaultCenter] postNotificationName:eventName object:self userInfo:userInfo];
}

- (void)fireModuleEvent:(Class)module eventName:(NSString *)eventName params:(NSDictionary*)params
{
    NSDictionary * userInfo = @{
                                @"moduleId":NSStringFromClass(module)?:@"",
                                @"param":params?:@{},
                                @"eventName":eventName
                                };
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MODULE_EVENT_FIRE_NOTIFICATION" object:self userInfo:userInfo];
}

- (NSURL *)completeURL:(NSString *)url
{
    if (!_scriptURL) {
        return [NSURL URLWithString:url];
    }
    if ([url hasPrefix:@"//"] && [_scriptURL isFileURL]) {
        return [NSURL URLWithString:url];
    }
    if (!url) {
        return nil;
    }
    NSURL *result = [NSURL URLWithString:url relativeToURL:_scriptURL];
    if (result) {
        return result;
    }
    // if result is nil, try url-encode the 'url' string.
    return [NSURL URLWithString:[url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]] relativeToURL:_scriptURL];
}

- (BOOL)checkModuleEventRegistered:(NSString*)event moduleClassName:(NSString*)moduleClassName
{
    NSDictionary * observer = [_moduleEventObservers objectForKey:moduleClassName];
    return observer && observer[event]? YES:NO;
}

#pragma mark Private Methods

- (void)_addModuleEventObserversWithModuleMethod:(YZModuleMethod *)method
{
    if ([method.arguments count] < 2) {
        NSLog(@"please check your method parameter!!");
        return;
    }
    if(![method.arguments[0] isKindOfClass:[NSString class]]) {
        // arguments[0] will be event name, so it must be a string type value here.
        return;
    }
    NSMutableArray * methodArguments = [method.arguments mutableCopy];
    if ([methodArguments count] == 2) {
        [methodArguments addObject:@{@"once": @false}];
    }
    if (![methodArguments[2] isKindOfClass:[NSDictionary class]]) {
        //arguments[2] is the option value, so it must be a dictionary.
        return;
    }
    Class moduleClass =  [YZModuleFactory classWithModuleName:method.moduleName];
    NSMutableDictionary * option = [methodArguments[2] mutableCopy];
    [option setObject:method.moduleName forKey:@"moduleName"];
    // the value for moduleName in option is for the need of callback
    [self addModuleEventObservers:methodArguments[0] callback:methodArguments[1] option:option moduleClassName:NSStringFromClass(moduleClass)];
}

- (void)addModuleEventObservers:(NSString*)event callback:(NSString*)callbackId option:(NSDictionary *)option moduleClassName:(NSString*)moduleClassName
{
    BOOL once = [[option objectForKey:@"once"] boolValue];
    NSString * moduleName = [option objectForKey:@"moduleName"];
    NSMutableDictionary * observer = nil;
    NSDictionary * callbackInfo = @{@"callbackId":callbackId,@"once":@(once),@"moduleName":moduleName};
    if(![self checkModuleEventRegistered:event moduleClassName:moduleClassName]) {
        //had not registered yet
        observer = [NSMutableDictionary new];
        [observer setObject:[@{event:[@[callbackInfo] mutableCopy]} mutableCopy] forKey:moduleClassName];
        if (_moduleEventObservers[moduleClassName]) { //support multi event
            [_moduleEventObservers[moduleClassName] addEntriesFromDictionary:observer[moduleClassName]];
        }else {
            [_moduleEventObservers addEntriesFromDictionary:observer];
        }
    } else {
        observer = _moduleEventObservers[moduleClassName];
        [[observer objectForKey:event] addObject:callbackInfo];
    }
}

- (void)_removeModuleEventObserverWithModuleMethod:(YZModuleMethod *)method
{
    if (![method.arguments count] && [method.arguments[0] isKindOfClass:[NSString class]]) {
        return;
    }
    Class moduleClass =  [YZModuleFactory classWithModuleName:method.moduleName];
    [self removeModuleEventObserver:method.arguments[0] moduleClassName:NSStringFromClass(moduleClass)];
}

- (void)removeModuleEventObserver:(NSString*)event moduleClassName:(NSString*)moduleClassName
{
    if (![self checkModuleEventRegistered:event moduleClassName:moduleClassName]) {
        return;
    }
    [_moduleEventObservers[moduleClassName] removeObjectForKey:event];
}

- (void)moduleEventNotification:(NSNotification *)notification
{
}

- (void)addObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moduleEventNotification:) name:@"MODULE_EVENT_FIRE_NOTIFICATION" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [self addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)removeObservers
{
    @try {
        [self removeObserver:self forKeyPath:@"state" context:NULL];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
    @catch (NSException *exception) {//!OCLint
    }
}


- (void)applicationWillResignActive:(NSNotification*)notification
{
    [self fireGlobalEvent:@"APPLICATION_WILL_RESIGN_ACTIVE" params:nil];
}

- (void)applicationDidBecomeActive:(NSNotification*)notification
{
    [self fireGlobalEvent:@"APPLICATION_DID_BECOME_ACTIVE" params:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    // waite
}
@end
