

#import <JavaScriptCore/JavaScriptCore.h>

@interface JSValue (JS)

+ (JSValue *)yz_valueWithReturnValueFromInvocation:(NSInvocation *)invocation inContext:(JSContext *)context;

@end
