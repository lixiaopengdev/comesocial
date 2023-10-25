
#import "JSContext+JS.h"
#import <objc/runtime.h>

static NSString *yz_instanceIdKey;

@implementation JSContext (JS)

- (NSString *)instanceId {
    return (NSString *)objc_getAssociatedObject(self, &yz_instanceIdKey);
}

- (void)setInstanceId:(NSString *)instanceId {
    objc_setAssociatedObject(self, &yz_instanceIdKey, instanceId, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
