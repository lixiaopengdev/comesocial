

#import <UIKit/UIKit.h>
#import "YZSDKInstance.h"

@protocol YZModuleProtocol <NSObject>

@optional

/**
 *  @abstract returns the execute queue for the module
 *
 *  @return dispatch queue that module's methods will be invoked on
 *
 *  @discussion the implementation is optional. Implement it if you want to execute module actions in the special queue.
 *  Default dispatch queue will be the main queue.
 *
 */
- (dispatch_queue_t _Nonnull )targetExecuteQueue;

/**
 *  @abstract returns the execute thread for the module
 *
 *  @return  thread that module's methods will be invoked on
 *
 *  @discussion the implementation is optional. If you want to execute module actions in the special thread, you can create a new one. 
 *  If `targetExecuteQueue` is implemented,  the queue returned will be respected first.
 *  Default is the main thread.
 *
 */
- (NSThread *_Nullable)targetExecuteThread;

@end

