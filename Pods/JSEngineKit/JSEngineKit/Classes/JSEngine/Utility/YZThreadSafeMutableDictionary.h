

#import <Foundation/Foundation.h>

/**
 *  @abstract Thread safe NSMutableDictionary
 */
@interface YZThreadSafeMutableDictionary<KeyType, ObjectType> : NSMutableDictionary

- (instancetype)init;
- (instancetype)initWithCapacity:(NSUInteger)numItems;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (instancetype)initWithCoder:(NSCoder *)aDecoder;
- (instancetype)initWithObjects:(const id [])objects forKeys:(const id<NSCopying> [])keys count:(NSUInteger)cnt;

- (NSUInteger)count;
- (id)objectForKey:(id)key;
- (id)objectForKeyedSubscript:(id)key;
- (NSEnumerator *)keyEnumerator;
- (void)setObject:(id)anObject forKey:(id<NSCopying>)aKey;
- (void)setObject:(id)anObject forKeyedSubscript:(id <NSCopying>)key;
- (NSArray *)allKeys;
- (NSArray *)allValues;
- (void)removeObjectForKey:(id)aKey;
- (void)removeAllObjects;

@end
