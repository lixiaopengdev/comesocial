

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JSValue+JS.h"
#import "YZThreadSafeMutableArray.h"
#import "YZThreadSafeMutableDictionary.h"
#define JSWeakSelf __weak __typeof(self)weakSelf = self;
#define JSStrongSelf __strong __typeof(weakSelf)self = weakSelf;

#ifdef __cplusplus
# define JS_EXTERN_C_BEGIN extern "C" {
# define JS_EXTERN_C_END   }
#else
# define JS_EXTERN_C_BEGIN
# define JS_EXTERN_C_END
#endif

#define YZ_ENUMBER_CASE(_invoke, idx, code, obj, _type, op, _flist) \
case code:{\
    _type *_tmp = malloc(sizeof(_type));\
    memset(_tmp, 0, sizeof(_type));\
    *_tmp = [obj op];\
    [_invoke setArgument:_tmp atIndex:(idx) + 2];\
    *(_flist + idx) = _tmp;\
    break;\
}
#define YZ_EPCHAR_CASE(_invoke, idx, code, obj, _type, op, _flist) \
case code:{\
    _type *_tmp = (_type  *)[obj op];\
    [_invoke setArgument:&_tmp atIndex:(idx) + 2];\
    *(_flist + idx) = 0;\
    break;\
}\

#define YZ_ALLOC_FLIST(_ppFree, _count) \
do {\
    _ppFree = (void *)malloc(sizeof(void *) * (_count));\
    memset(_ppFree, 0, sizeof(void *) * (_count));\
} while(0)

#define YZ_FREE_FLIST(_ppFree, _count) \
do {\
    for(int i = 0; i < (_count); i++){\
        if(*(_ppFree + i ) != 0) {\
            free(*(_ppFree + i));\
        }\
    }\
    free(_ppFree);\
}while(0)

#define YZ_ARGUMENTS_SET(_invocation, _sig, idx, _obj, _ppFree) \
do {\
    const char *encode = [_sig getArgumentTypeAtIndex:(idx) + 2];\
    switch(encode[0]){\
        YZ_EPCHAR_CASE(_invocation, idx, _C_CHARPTR, _obj, char *, UTF8String, _ppFree)\
        YZ_ENUMBER_CASE(_invocation, idx, _C_INT, _obj, int, intValue, _ppFree)\
        YZ_ENUMBER_CASE(_invocation, idx, _C_SHT, _obj, short, shortValue, _ppFree)\
        YZ_ENUMBER_CASE(_invocation, idx, _C_LNG, _obj, long, longValue, _ppFree)\
        YZ_ENUMBER_CASE(_invocation, idx, _C_LNG_LNG, _obj, long long, longLongValue, _ppFree)\
        YZ_ENUMBER_CASE(_invocation, idx, _C_UCHR, _obj, unsigned char, unsignedCharValue, _ppFree)\
        YZ_ENUMBER_CASE(_invocation, idx, _C_UINT, _obj, unsigned int, unsignedIntValue, _ppFree)\
        YZ_ENUMBER_CASE(_invocation, idx, _C_USHT, _obj, unsigned short, unsignedShortValue, _ppFree)\
        YZ_ENUMBER_CASE(_invocation, idx, _C_ULNG, _obj, unsigned long, unsignedLongValue, _ppFree)\
        YZ_ENUMBER_CASE(_invocation, idx, _C_ULNG_LNG, _obj,unsigned long long, unsignedLongLongValue, _ppFree)\
        YZ_ENUMBER_CASE(_invocation, idx, _C_FLT, _obj, float, floatValue, _ppFree)\
        YZ_ENUMBER_CASE(_invocation, idx, _C_DBL, _obj, double, doubleValue, _ppFree)\
        YZ_ENUMBER_CASE(_invocation, idx, _C_BOOL, _obj, bool, boolValue, _ppFree)\
        YZ_ENUMBER_CASE(_invocation, idx, _C_CHR, _obj, char, charValue, _ppFree)\
        default: { [_invocation setArgument:&_obj atIndex:(idx) + 2]; *(_ppFree + idx) = 0; break;}\
    }\
}while(0)

#ifdef __cplusplus
extern "C" {
#endif
    
/**
 * @abstract execute asynchronous action block on the main thread.
 *
 */
void YZPerformBlockOnMainThread( void (^ _Nonnull block)(void));

/**
 * @abstract execute synchronous action block on the main thread.
 *
 */
void YZPerformBlockSyncOnMainThread( void (^ _Nonnull block)(void));

/**
 * @abstract execute action block on the specific thread.
 *
 */
void YZPerformBlockOnThread(void (^ _Nonnull block)(void), NSThread *_Nonnull thread);

/**
 * @abstract swizzling methods.
 *
 */
void YZSwizzleInstanceMethod(_Nonnull Class className, _Nonnull SEL original, _Nonnull SEL replaced);

void YZSwizzleInstanceMethodWithBlock(_Nonnull Class className, _Nonnull SEL original, _Nonnull id block, _Nonnull SEL replaced);

_Nonnull SEL YZSwizzledSelectorForSelector(_Nonnull SEL selector);
    
#ifdef __cplusplus
}
#endif

@interface YZUtility : NSObject

+ (void)performBlock:(void (^_Nonnull)(void))block onThread:(NSThread *_Nonnull)thread;

/**
 * @abstract Returns the environment of current application, you can get some necessary properties such as appVersion、sdkVersion、appName etc.
 *
 * @return A dictionary object which contains these properties.
 *
 */
+ (NSDictionary *_Nonnull)getEnvironment;
+ (NSDictionary *_Nonnull)getEnvironmentForJSContext;


/**
 * @abstract JSON Decode Method
 *
 * @param json String.
 *
 * @return A json object by decoding json string.
 *
 */
+ (id _Nullable)objectFromJSON:(NSString * _Nonnull)json;

/**
 Convert all sub-structure objects of source to immutable container.

 @param source Source object.
 @return Converted object using immutable container.
 */
+ (id _Nullable)convertContainerToImmutable:(id _Nullable)source;

#define YZDecodeJson(json)  [YZUtility objectFromJSON:json]

/**
 * @abstract JSON Encode Method
 *
 * @param object Object.
 *
 * @return A json string by encoding json object.
 *
 */
+ (NSString * _Nullable)JSONString:(id _Nonnull)object;

#define YZEncodeJson(obj)  [YZUtility JSONString:obj]

/**
 * @abstract Returns a Foundation object from given JSON data. A Foundation object from the JSON data in data, or nil if an error occurs.
 *
 * @param data A data object containing JSON data.
 * @param error If an error occurs, upon return contains an NSError object that describes the problem.
 *
 * @return A Foundation object from the JSON data in data, or nil if an error occurs.
 *
 */
+ (id _Nullable)JSONObject:(NSData * _Nonnull)data error:(NSError * __nullable * __nullable)error;

#define YZJSONObjectFromData(data) [YZUtility JSONObject:data error:nil]
/**
 * @abstract JSON Object Copy Method
 *
 * @param object Object.
 *
 * @return A json object by copying.
 *
 */
+ (id _Nullable)copyJSONObject:(id _Nonnull)object;

#define YZCopyJson(obj)     [YZUtility copyJSONObject:obj]

/**
 *
 *  Checks if a String is whitespace, empty ("") or nil
 *  @code
 *    [YZUtility isBlankString: nil]       = true
 *    [YZUtility isBlankString: ""]        = true
 *    [YZUtility isBlankString: " "]       = true
 *    [YZUtility isBlankString: "bob"]     = false
 *    [YZUtility isBlankString: "  bob  "] = false
 *  @endcode
 *  @param string the String to check, may be null
 *
 *  @return true if the String is null, empty or whitespace
 */
+ (BOOL)isBlankString:(NSString * _Nullable)string ;


/**
 check a point is valid or not. A zero point is also valid

 @param point a point value to check
 @return true if point.x and point.y are all valid value for a number.
 */


#if defined __cplusplus
extern "C" {
#endif

#if defined __cplusplus
};
#endif
    
/**
 *  @abstract check whether the file is exist
 *
 */

+ (BOOL)isFileExist:(NSString * _Nonnull)filePath;
/**
 *  @abstract Returns the document directory path.
 *
 */
+ (NSString *_Nonnull)documentDirectory;

#define YZDocumentPath     [YZUtility documentDirectory]

/**
 *  @abstract Returns the system cache directory path.
 *
 */
+ (NSString *_Nonnull)cacheDirectory;

#define YZCachePath     [YZUtility cacheDirectory]

/**
 *  @abstract Returns the system library directory path.
 *
 */
+ (NSString *_Nonnull)libraryDirectory;

#define YZLibraryPath  [YZUtility libraryDirectory]

/**
 *  @abstract Returns the contents of file.
 *
 */
+ (NSString *_Nullable)stringWithContentsOfFile:(NSString *_Nonnull)filePath;

/**
 *  @abstract Returns md5 string.
 *
 */
+ (NSString *_Nullable)md5:(NSString *_Nullable)string;

/**
 *  @abstract Returns Creates a Universally Unique Identifier (UUID) string.
 *
 */
+ (NSString *_Nullable)uuidString;

/**
 *  @abstract convert date string with formatter yyyy-MM-dd to date.
 *
 */
+ (NSDate *_Nullable)dateStringToDate:(NSString *_Nullable)dateString;

/**
 *  @abstract convert time string with formatter HH:mm to date.
 *
 */
+ (NSDate *_Nullable)timeStringToDate:(NSString *_Nullable)timeString;

/**
 *  @abstract convert date to date string with formatter yyyy-MM-dd .
 *
 */
+ (NSString *_Nullable)dateToString:(NSDate *_Nullable)date;

/**
 *  @abstract convert date to time string with formatter HH:mm .
 *
 */
+ (NSString *_Nullable)timeToString:(NSDate *_Nullable)date;

/**
 *  @abstract get the repeat substring number of string.
 *
 */
+ (NSUInteger)getSubStringNumber:(NSString *_Nullable)string subString:(NSString *_Nullable)subString;

/**
 *  @abstract convert returnKeyType to type string .
 *
 */
+ (NSString *_Nullable)returnKeyType:(UIReturnKeyType)type;

/**
 *  @abstract format to base64 dictionary
 *
 */
+ (NSDictionary *_Nonnull)dataToBase64Dict:(NSData *_Nullable)data;

/**
 *  @abstract format to data
 *
 */
+ (NSData *_Nonnull)base64DictToData:(NSDictionary *_Nullable)base64Dict;

+ (NSArray<NSString *> *_Nullable)extractPropertyNamesOfJSValueObject:(JSValue *_Nullable)jsvalue;


+ (id _Nullable)parseValue:(JSValue *_Nullable)value;
@end
