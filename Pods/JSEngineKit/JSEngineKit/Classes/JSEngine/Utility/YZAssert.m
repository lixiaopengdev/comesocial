

#import "YZAssert.h"

void YZAssertInternal(NSString *func, NSString *file, int lineNum, NSString *format, ...)
{
    va_list args;
    va_start(args, format);
    NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    
    NSLog(@"%@", message);
    [[NSAssertionHandler currentHandler] handleFailureInFunction:func file:file lineNumber:lineNum description:format, message];
}
