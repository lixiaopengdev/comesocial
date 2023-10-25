
#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "YZJSEngineProtocol.h"

@class YZCallJSMethod;
@class YZSDKInstance;

@interface YZJSEngineContext : NSObject

/**
 *  Destroy Instance Method
 *  @param instanceId  :   instance id
 **/
- (void)destroyContext:(NSString *)instanceId;

/**
 *  setInstanceId Method
 *  @param instanceId  :   instance id
 **/
- (void)setInstanceId:(NSString *)instanceId;

/**
 *  Update Instance State Method
 *  @param instance  :   instance id
 *  @param data      :   parameters
 **/
- (void)updateState:(NSString *)instance
               data:(id)data;

/**
 *  Execute JS Method
 *  @param method    :   object of engine method
 **/
- (void)executeJsMethod:(YZCallJSMethod *)method;

- (JSValue *)excuteJSMethodWithResult:(YZCallJSMethod *)method;

/**
 *  Register Modules Method
 *  @param modules   :   module list
 **/
- (void)registerModules:(NSDictionary *)modules;

/**
 *  register Handler
 *  @param eventName  :   name
 *  @param block : call back block
 **/
- (void)registerHandler:(NSString *)eventName  withBlock:(YZJSCallNativeBlock)block;

/**
 *  Execute JS file
 *  @param script    :   JS  script
 **/
- (void)executeJsFile:(NSString *)script;

- (void)executeJsFiles:(NSString *)path;

/**
 *  callJS Method
 *  @param args    :   JS  args
 *  @param completion    :   JS  engine
 **/
- (void)callJSMethod:(NSString *)method
                args:(NSArray *)args
          completion:(void (^)(id data))completion;

/**
 *  getJsSettings
 *  @param filePath    :   JS  path
 **/
- (void)getJsSettings:(NSString *)filePath completion:(void (^)(id))completion;
- (void)setJsSettings:(NSDictionary *)dict completion:(void (^)(id))completion;
@end
