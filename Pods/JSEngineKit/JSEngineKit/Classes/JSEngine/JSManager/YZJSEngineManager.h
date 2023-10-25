
#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "YZJSEngineContext.h"
NS_ASSUME_NONNULL_BEGIN

#define JSEngineManager [YZJSEngineManager sharedManager]


#ifdef __cplusplus
extern "C" {
#endif
    void YZPerformBlockOnJSEngineThread(void (^block)(void));
    void YZPerformBlockSyncOnJSEngineThread(void (^block) (void));

    void YZPerformBlockOnJSEngineThreadForInstance(void (^block)(void), NSString* instance);
    void YZPerformBlockSyncOnJSEngineThreadForInstance(void (^block) (void), NSString* instance);
#ifdef __cplusplus
}
#endif

@interface YZJSEngineManager : NSObject

+ (instancetype)sharedManager;

/**
 *  register Handler
 *  @param eventName  :   instance id
 *  @param block : call back block
 */
- (void)registerHandler:(NSString *)eventName withBlock:(YZJSCallNativeBlock)block;

/**
 *  register Provider
 *  @param provider  :   obj
 *  @param protocol :  protocol
 */
- (void)registerProvider:(id)provider withProtocol:(Protocol *)protocol;

/**
 *  Destroy Instance Method
 *  @param instanceId  :   instance id
 */
- (void)destroyInstance:(NSString *)instanceId;

/**
 *  Register Modules Method
 *  @param name   :   module  name
 */
- (void)registerModule:(NSString *)name withClass:(Class)clazz;


/**
 *  execute Js Method
 *  @param instanceId : must contain instanceId
 *  @param args : call args
 */
- (void)callJSMethod:(NSString *)method
          instanceId:(NSString *)instanceId
                args:(NSArray * _Nullable)args;

/**
 *  execute Js Method with call back
 *  @param args :  call args
 *  @param instanceId : must contain instanceId
 *  @param completion : need call back
 */
- (void)callJSMethod:(NSString *)method
           instanceId:(NSString *)instanceId
                args:(NSArray * _Nullable)args
          completion:(void (^ _Nullable)(id data))completion;

/**
 *  Js Settings Method
 *  @param instanceId : instanceId
 *  @param filePath : js path
 *  @param completion : call back
 */
- (void)getJsSettingsWithInstanceId:(NSString *)instanceId filePath:(NSString *)filePath completion:(void (^ _Nullable)(id data))completion;

/**
 *  execute Js Method
 *  @param instanceId :  instanceId
 *  @param arr :  set dict
 *  @param completion :  call back
 */
- (void)setJsSettingsWithInstanceId:(NSString *)instanceId arr:(NSDictionary *)dict completion:(void (^)(id _Nullable))completion;

/**
 * set JS path
 */
-(void)registerJSPath:(NSString *)path instanceId:(NSString *)instanceId;

@end

NS_ASSUME_NONNULL_END
