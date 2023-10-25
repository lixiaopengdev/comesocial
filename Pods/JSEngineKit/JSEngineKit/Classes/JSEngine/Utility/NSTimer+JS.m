

#import "NSTimer+JS.h"

@implementation NSTimer (JS)

+ (NSTimer *)js_scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                         block:(void(^)(void))block
                                       repeats:(BOOL)repeats
{
    return [self scheduledTimerWithTimeInterval:interval
                                         target:self
                                       selector:@selector(blockInvoke:)
                                       userInfo:[block copy]
                                        repeats:repeats];
}

+ (void)blockInvoke:(NSTimer*)timer
{
    void (^block)(void) = timer.userInfo;
    if (block) {
        block();
    }
}

@end
