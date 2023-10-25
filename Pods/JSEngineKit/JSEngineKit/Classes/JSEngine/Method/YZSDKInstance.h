

#import <UIKit/UIKit.h>
#import "YZJSEngineProtocol.h"

NS_ASSUME_NONNULL_BEGIN

typedef BOOL (^YZModuleInterceptCallback)(NSString *moduleName, NSString *methodName, NSArray *arguments, NSDictionary *options);

@interface YZSDKInstance : NSObject

/**
 * Init instance and render it using iOS native views.
 * It is the same as initWithRenderType:@"platform"
 **/
- (instancetype)init;

/**
 * The render type. Default is "platform"
 **/
@property (nonatomic, strong, readonly) NSString* renderType;



/**
 * The scriptURL of js bundle.
 **/
@property (nonatomic, strong) NSURL *scriptURL;

/**
 * The unique id to identify current instanceId.
 **/
@property (nonatomic, strong) NSString *instanceId;

/**
 * bundleType is the DSL type
 */
@property (nonatomic, strong) NSString * bundleType;
    
/**
 *  The callback triggered when the instance fails to render.
 *
 *  @return A block that takes a NSError argument, which is the error occured
 **/
@property (nonatomic, copy) void (^onFailed)(NSError *error);


/**
 * get module instance by class
 */
- (id)moduleForClass:(Class)moduleClass;


/**
 * check whether the module eventName is registered
 */
- (BOOL)checkModuleEventRegistered:(NSString*)event moduleClassName:(NSString*)moduleClassName;

/**
 * fire module event;
 * @param module which module you fire event to
 * @param eventName the event name
 * @param params event params
 */
- (void)fireModuleEvent:(Class)module eventName:(NSString *)eventName params:(NSDictionary* _Nullable)params;

/**
 * fire global event
 */
- (void)fireGlobalEvent:(NSString *)eventName params:(NSDictionary * _Nullable)params;

/**
 * complete url based with bundle url
 */
- (NSURL *)completeURL:(NSString *)url;


/**
 * application performance statistics
 */
@property (nonatomic, strong) NSString *bizType;
@property (nonatomic, strong) NSString *pageName;
@property (nonatomic, weak) id pageObject;

@property (nonatomic, assign) BOOL appearState;

/** 
 * Deprecated 
 */
@property (nonatomic, strong) NSDictionary *properties DEPRECATED_MSG_ATTRIBUTE();
@property (nonatomic, assign) NSTimeInterval networkTime DEPRECATED_MSG_ATTRIBUTE();
@property (nonatomic, copy) void (^updateFinish)(UIView *);

@end

NS_ASSUME_NONNULL_END
