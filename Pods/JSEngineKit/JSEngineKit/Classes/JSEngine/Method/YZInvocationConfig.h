

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YZInvocationConfig : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *clazz;
/**
 *  The methods map
 **/
@property (nonatomic, strong) NSMutableDictionary *asyncMethods;
@property (nonatomic, strong) NSMutableDictionary *syncMethods;

- (instancetype)initWithName:(NSString *)name class:(NSString *)clazz;
- (void)registerMethods;

@end

NS_ASSUME_NONNULL_END
