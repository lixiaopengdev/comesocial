

#import "YZJSEngineManager.h"
#import "YZJSEngineContext.h"
#import "YZAssert.h"
#import "YZJSEngineMethod.h"
#import "YZCallJSMethod.h"
#import "YZThreadSafeMutableDictionary.h"
#import "YZUtility.h"
#import "YZJSMethodDefine.h"
#import "YZModuleFactory.h"
#import "YZNativeMethodManager.h"
@interface YZJSEngineManager ()

@property (nonatomic, assign) BOOL stopRunning;
@property (nonatomic, assign) BOOL supportMultiJSThread;
@property (nonatomic, strong) YZThreadSafeMutableDictionary* jsProviders;
@property (nonatomic, copy) NSString *jsPath;
@property (nonatomic, strong) YZThreadSafeMutableDictionary *ctxDictionary;
@property (nonatomic, strong) YZThreadSafeMutableDictionary *taskHandlers;
@property (nonatomic, strong) YZThreadSafeMutableArray *modulesArray;
@end

static NSThread *YZJSEngineThread;

@implementation YZJSEngineManager

+ (instancetype)sharedManager
{
    static id _sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _taskHandlers = [[YZThreadSafeMutableDictionary alloc] init];
        _supportMultiJSThread = NO;
        _jsProviders = [[YZThreadSafeMutableDictionary alloc] init];
    }
    return self;
}

- (YZThreadSafeMutableDictionary *)ctxDictionary
{
    if (_ctxDictionary == nil) {
        _ctxDictionary = [[YZThreadSafeMutableDictionary alloc] init];
    }
    return _ctxDictionary;
}

- (YZThreadSafeMutableArray *)modulesArray {
    if (_modulesArray == nil) {
        _modulesArray = [[YZThreadSafeMutableArray alloc] init];
    }
    return _modulesArray;
}

- (YZJSEngineContext *)getJSContext:(NSString *)instanceId
{
    if (instanceId == nil) {
        return nil;
    }
    YZJSEngineContext *ctx = self.ctxDictionary[instanceId];
    if (ctx) {
        return ctx;
    }
    YZJSEngineContext *context = [[YZJSEngineContext alloc] init];
    [context setInstanceId:instanceId];
    [self.ctxDictionary setObject:context forKey:instanceId];
    [self runTaskHandlers:context];
    for (NSDictionary *dict in self.modulesArray) {
        [self registerModuleContext:context modules:dict];
    }
    [YZNativeMethodManager registerNativeFunctions:context provider:self.jsProviders];
    return context;
}

- (void)registerNativeFunctions:(YZJSEngineContext *)context
{
    
}

- (void)runTaskHandlers:(YZJSEngineContext *)context {
    JSWeakSelf
    for (NSString *eventName in self.taskHandlers.allKeys) {
        [context registerHandler:eventName withBlock:^id(NSString * _Nonnull instanceId, NSString * _Nonnull eventName, NSDictionary * _Nonnull options) {
            JSStrongSelf
            YZJSCallNativeBlock block = self.taskHandlers[eventName];
            if (block) {
                block(instanceId, eventName ,options);
            }
            return nil;
        }];
    }
}

- (void)runEventHandlers:(NSString *)evnetName callBack:(YZJSCallNativeBlock)block {
    for (NSString *insId in self.ctxDictionary.allKeys) {
        YZJSEngineContext *ctx = self.ctxDictionary[insId];
        [ctx registerHandler:evnetName withBlock:block];
    }
}

#pragma mark Thread Management

- (void)_runLoopThread
{
    [[NSRunLoop currentRunLoop] addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
    
    while (!_stopRunning) {
        @autoreleasepool {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
    }
}

+ (NSThread *)jsThread
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        YZJSEngineThread = [[NSThread alloc] initWithTarget:[[self class]sharedManager] selector:@selector(_runLoopThread) object:nil];
        [YZJSEngineThread setName:@"js.engine"];
        [YZJSEngineThread setQualityOfService:[[NSThread mainThread] qualityOfService]];
        [YZJSEngineThread start];
    });

    return YZJSEngineThread;
}

void YZPerformBlockOnJSEngineThread(void (^block)(void))
{
    [YZJSEngineManager _performBlockOnJSEngineThread:block];
}

void YZPerformBlockOnJSEngineThreadForInstance(void (^block)(void), NSString* instance) {
    [YZJSEngineManager _performBlockOnJSEngineThread:block instance:instance];
}

+ (void)_performBlockOnJSEngineThread:(void (^)(void))block
{
    if ([NSThread currentThread] == [self jsThread]) {
        block();
    } else {
        [self performSelector:@selector(_performBlockOnJSEngineThread:)
                         onThread:[self jsThread]
                       withObject:[block copy]
                    waitUntilDone:NO];
    }
}

+ (void)_performBlockOnJSEngineThread:(void (^)(void))block instance:(NSString*)instanceId
{

    if ([NSThread currentThread] == [self jsThread]) {
        block();
    } else {
        [self performSelector:@selector(_performBlockOnJSEngineThread:instance:)
                     onThread:[self jsThread]
                   withObject:[block copy]
                waitUntilDone:NO];
        
    }
}

void YZPerformBlockSyncOnJSEngineThread(void (^block) (void)) {
    [YZJSEngineManager _performBlockSyncOnJSEngineThread:block];
}

void YZPerformBlockSyncOnJSEngineThreadForInstance(void (^block) (void), NSString* instance)
{
    [YZJSEngineManager _performBlockSyncOnJSEngineThread:block instance:instance];
}

+ (void)_performBlockSyncOnJSEngineThread:(void (^)(void))block
{
    if ([NSThread currentThread] == [self jsThread]) {
        block();
    } else {
        [self performSelector:@selector(_performBlockSyncOnJSEngineThread:)
                     onThread:[self jsThread]
                   withObject:[block copy]
                waitUntilDone:YES];
    }
}

+ (void)_performBlockSyncOnJSEngineThread:(void (^)(void))block instance:(NSString*)instanceId
{

    if ([NSThread currentThread] == [self jsThread]) {
        block();
    } else {
        [self performSelector:@selector(_performBlockSyncOnJSEngineThread:instance:)
                     onThread:[self jsThread]
                   withObject:[block copy]
                waitUntilDone:YES];
        
    }
}

- (void)getJsSettingsWithInstanceId:(NSString *)instanceId filePath:(NSString *)filePath completion:(void (^ _Nullable)(id _Nullable))completion
{
    [[self getJSContext:instanceId] getJsSettings:filePath completion:completion];
}

- (void)setJsSettingsWithInstanceId:(NSString *)instanceId arr:(nonnull NSDictionary *)dict completion:(void (^)(id _Nullable))completion
{
    [[self getJSContext:instanceId] setJsSettings:dict completion:completion];
}

#pragma mark JSEngine Management

- (void)destroyInstance:(NSString *)instanceId
{
    if (!instanceId) return;
    YZJSEngineContext *ctx = self.ctxDictionary[instanceId];
    if (ctx) {
        [ctx destroyContext:instanceId];
        [self.ctxDictionary removeObjectForKey:instanceId];
    }
}

- (void)updateState:(NSString *)instanceId data:(id)data
{
    if (!instanceId) return;
    
    __weak typeof(self) weakSelf = self;
    YZPerformBlockOnJSEngineThreadForInstance(^(){
        YZJSEngineContext* context = [weakSelf getJSContext:instanceId];
        [context updateState:instanceId data:data];
    }, instanceId);
}

- (void)callJsMethod:(YZCallJSMethod *)method
{
    if (!method || !method.instance) return;
    
    __weak typeof(self) weakSelf = self;
    YZPerformBlockOnJSEngineThreadForInstance(^(){
        YZJSEngineContext* context = [weakSelf getJSContext:nil];
        [context executeJsMethod:method];
    }, @"instanceId");
}

- (JSValue *)callJSMethodWithResult:(YZCallJSMethod *)method
{
    if (!method || !method.instance) return nil;
    __weak typeof(self) weakSelf = self;
    __block JSValue *value;
    YZPerformBlockSyncOnJSEngineThreadForInstance(^(){
        YZJSEngineContext* context = [weakSelf getJSContext:nil];
        value = [context excuteJSMethodWithResult:method];
    }, @"instanceId");
    return value;
}


- (void)registerModule:(NSString *)name withClass:(Class)clazz
{
    YZAssert(name && clazz, @"Fail to register the module, please check if the parameters are correct ！");
    if (!clazz || !name) {
        return;
    }
    NSString *moduleName = [YZModuleFactory registerModule:name withClass:clazz];
    NSDictionary *dict = [YZModuleFactory moduleMethodMapsWithName:moduleName];
    
    [self registerModules:dict];
}

- (void)registerModules:(NSDictionary *)modules
{
    if (!modules) return;
    
    modules = [YZUtility convertContainerToImmutable:modules];
    NSLog(@"Register modules: %@", modules);
    
    [self.modulesArray addObject:modules];
    for (NSString *instanceId in self.ctxDictionary.allKeys) {
        YZJSEngineContext *ctx = [self.ctxDictionary objectForKey:instanceId];
        [self registerModuleContext:ctx modules:modules];
    }
}

- (void)registerModuleContext:(YZJSEngineContext *)ctx modules:(NSDictionary *)modules
{
    YZPerformBlockOnJSEngineThread(^(){
        [ctx registerModules:modules];
    });
}

- (void)registerHandler:(NSString *)eventName withBlock:(YZJSCallNativeBlock)block {
    if (eventName !=nil && block!= nil) {
        [self.taskHandlers setObject:block forKey:eventName];
        [self runEventHandlers:eventName callBack:block];
    }
}

- (void)registerProvider:(id)provider withProtocol:(Protocol *)protocol {
    if (provider != nil){
        [self.jsProviders setObject:provider forKey:NSStringFromProtocol(protocol)];
    }
}

- (id)providersForProtocol:(Protocol *)protocol
{
    id provider = [self.jsProviders objectForKey:NSStringFromProtocol(protocol)];
    return provider;
}

- (void)registerJSPath:(NSString *)path instanceId:(NSString *)instanceId
{
    [[self getJSContext:instanceId] executeJsFiles:path];
}

- (void)fireEvent:(NSString *)instanceId ref:(NSString *)ref type:(NSString *)type params:(NSDictionary *)params domChanges:(NSDictionary *)domChanges
{
    [self fireEvent:instanceId ref:ref type:type params:params domChanges:domChanges handlerArguments:nil];
}

- (void)fireEvent:(NSString *)instanceId ref:(NSString *)ref type:(NSString *)type params:(NSDictionary *)params domChanges:(NSDictionary *)domChanges handlerArguments:(NSArray *)handlerArguments
{
    YZCallJSMethod *method = [[YZCallJSMethod alloc] initWithModuleName:nil methodName:@"fireEvent" arguments:nil instance:nil];
    [self callJsMethod:method];
}

- (JSValue *)fireEventWithResult:(NSString *)instanceId ref:(NSString *)ref type:(NSString *)type params:(NSDictionary *)params domChanges:(NSDictionary *)domChanges
{
    if (!type || !ref) {
        NSLog(@"Event type and component ref should not be nil");
        return nil;
    }
    NSArray *args = @[ref, type, params?:@{}, domChanges?:@{}];
    YZCallJSMethod *method = [[YZCallJSMethod alloc] initWithModuleName:nil methodName:@"fireEvent" arguments:args instance:nil];
    return [self callJSMethodWithResult:method];
}

- (void)callBack:(NSString *)instanceId funcId:(NSString *)funcId params:(id)params keepAlive:(BOOL)keepAlive
{
    NSArray *args = nil;
    if (keepAlive) {
        args = @[[funcId copy], params? [params copy]:@"\"{}\"", @true];
    } else {
        args = @[[funcId copy], params? [params copy]:@"\"{}\""];
    }
    
    YZCallJSMethod *method = [[YZCallJSMethod alloc] initWithModuleName:@"jsEngine" methodName:@"callback" arguments:args instance:nil];
    [self callJsMethod:method];
}

- (void)callBack:(NSString *)instanceId funcId:(NSString *)funcId params:(id)params
{
    [self callBack:instanceId funcId:funcId params:params keepAlive:NO];
}


- (void)callJSMethod:(NSString *)method instanceId:(nonnull NSString *)instanceId args:(NSArray * _Nullable)args completion:(void (^ _Nullable)(id _Nullable))completion {
    if (!method) return;

    __weak typeof(self) weakSelf = self;
    if (instanceId == nil) {
        return;
    }
    YZJSEngineContext* context = [weakSelf getJSContext:instanceId];
    [context callJSMethod:method args:args completion:completion];
}

- (void)callJSMethod:(NSString *)method instanceId:(NSString *)instanceId args:(NSArray * _Nullable)args {
    [self callJSMethod:method instanceId:instanceId args:args completion:nil];
}

#pragma mark JS Thread Check

- (void)_postTaskToJSEngineThread {
    __block BOOL taskFinished = NO;
    YZPerformBlockOnJSEngineThread(^{
        taskFinished = YES;
    });

    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (!weakSelf) {
            return;
        }
        if (!taskFinished) {
           
        }
    });
}

#pragma mark - Deprecated

- (void)executeJsMethod:(YZCallJSMethod *)method
{
    if (!method || !method.instance) return;
    
    YZPerformBlockOnJSEngineThreadForInstance(^(){
        YZJSEngineContext* context = nil;
        [context executeJsMethod:method];
    }, @"instanceId");
}

@end
