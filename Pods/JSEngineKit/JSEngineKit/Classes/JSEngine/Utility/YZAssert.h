#import <Foundation/Foundation.h>
#import "YZUtility.h"
JS_EXTERN_C_BEGIN
void YZAssertInternal(NSString *func, NSString *file, int lineNum, NSString *format, ...);

#if DEBUG
#define YZAssert(condition, ...) \
do{\
    if(!(condition)){\
        YZAssertInternal(@(__func__), @(__FILE__), __LINE__, __VA_ARGS__);\
    }\
}while(0)
#else
#define YZAssert(condition, ...)
#endif

/**
 *  @abstract macro for asserting that a parameter is required.
 */
#define YZAssertParam(name) YZAssert(name, \
@"the parameter '%s' is required", #name)

/**
 *  @abstract macro for asserting if the handler conforms to the protocol
 */
#define YZAssertProtocol(handler, protocol) YZAssert([handler conformsToProtocol:protocol], \
@"handler:%@ does not conform to protocol:%@", handler, protocol)

/**
 *  @abstract macro for asserting that the object is kind of special class.
 */
#define YZAssertClass(name,className) YZAssert([name isKindOfClass:[className class]], \
@"the variable '%s' is not a kind of '%s' class", #name,#className)

/**
 *  @abstract macro for asserting that we are running on the main thread.
 */
#define YZAssertMainThread() YZAssert([NSThread isMainThread], \
@"must be called on the main thread")

/**
 *  @abstract macro for asserting that we are running on the engine thread.
 */
#define YZAssertEngineThread() \
YZAssert([[NSThread currentThread].name isEqualToString:@"js.engine"] || [[NSThread currentThread].name isEqualToString:@"js.engine.back"], \
@"must be called on the engine thread")

JS_EXTERN_C_END
