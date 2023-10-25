

#import <Foundation/Foundation.h>

@interface NSTimer (JS)

+ (NSTimer *)js_scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                         block:(void(^)(void))block
                                       repeats:(BOOL)repeats;

@end
