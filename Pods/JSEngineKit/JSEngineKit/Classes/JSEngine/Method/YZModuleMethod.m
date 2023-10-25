

#import "YZModuleMethod.h"
#import "YZModuleFactory.h"
#import "YZModuleProtocol.h"
#import "YZUtility.h"
@implementation YZModuleMethod

- (instancetype)initWithModuleName:(NSString *)moduleName
                        methodName:(NSString *)methodName
                         arguments:(NSArray *)arguments
                           options:(NSDictionary *)options
                          instance:(YZSDKInstance *)instance
{
    if (self = [super initWithMethodName:methodName arguments:arguments instance:instance]) {
        _moduleName = moduleName;
        _options = options;
    }
    
    return self;
}

- (NSInvocation *)invoke
{
    
    NSLog(@"yzInteractionAnalyzer : [client][callnativemodulestart],%@,%@,%@",self.instance.instanceId,self.moduleName,self.methodName);
        
    Class moduleClass =  [YZModuleFactory classWithModuleName:_moduleName];
    if (!moduleClass) {
        NSString *errorMessage = [NSString stringWithFormat:@"Module：%@ doesn't exist, maybe it has not been registered", _moduleName];
        NSLog(@"%@",errorMessage);
        return nil;
    }
    
    id<YZModuleProtocol> moduleInstance = [self.instance moduleForClass:moduleClass];
    BOOL isSync = NO;
    SEL selector = [YZModuleFactory selectorWithModuleName:self.moduleName methodName:self.methodName isSync:&isSync];
   
    if (![moduleInstance respondsToSelector:selector]) {
        // if not implement the selector, then dispatch default module method
        if ([self.methodName isEqualToString:@"addEventListener"]) {
//            [self.instance _addModuleEventObserversWithModuleMethod:self];
        } else if ([self.methodName isEqualToString:@"removeAllEventListeners"]) {
//            [self.instance _removeModuleEventObserverWithModuleMethod:self];
        } else {
            NSString *errorMessage = [NSString stringWithFormat:@"method：%@ for module:%@ doesn't exist, maybe it has not been registered", self.methodName, _moduleName];
            NSLog(@"%@",errorMessage);
            
        }
        return nil;
    }
	
    NSInvocation *invocation = [self invocationWithTarget:moduleInstance selector:selector];
    
    if (isSync) {
        [invocation invoke];
        NSLog(@"yzInteractionAnalyzer : [client][callnativemoduleEnd],%@,%@,%@",self.instance.instanceId,self.moduleName,self.methodName);
    
        return invocation;
    } else {
        [self _dispatchInvocation:invocation moduleInstance:moduleInstance];
        return nil;
    }
}


- (void)_dispatchInvocation:(NSInvocation *)invocation moduleInstance:(id<YZModuleProtocol>)moduleInstance
{
    // dispatch to user specified queue or thread, default is main thread
    dispatch_block_t dispatchBlock = ^ (){
        [invocation invoke];
        NSLog(@"yzInteractionAnalyzer : [client][callnativemoduleEnd],%@,%@,%@",self.instance.instanceId,self.moduleName,self.methodName);
    };
    
    NSThread *targetThread = nil;
    dispatch_queue_t targetQueue = nil;
    if([moduleInstance respondsToSelector:@selector(targetExecuteQueue)]){
        targetQueue = [moduleInstance targetExecuteQueue] ?: dispatch_get_main_queue();
    } else if([moduleInstance respondsToSelector:@selector(targetExecuteThread)]){
        targetThread = [moduleInstance targetExecuteThread] ?: [NSThread mainThread];
    } else {
        targetThread = [NSThread mainThread];
    }
    
    if (targetQueue) {
        dispatch_async(targetQueue, dispatchBlock);
    } else {
        YZPerformBlockOnThread(^{
            dispatchBlock();
        }, targetThread);
    }
}

@end
