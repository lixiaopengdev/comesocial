/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 * 
 *   http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

#import "YZUtility.h"
#import "YZThreadSafeMutableDictionary.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import <sys/utsname.h>
#import <UIKit/UIScreen.h>
#import <Security/Security.h>
#import <CommonCrypto/CommonCrypto.h>
#import <CoreText/CoreText.h>
#import "YZAssert.h"


void YZPerformBlockOnMainThread(void (^ _Nonnull block)(void))
{
    if (!block) return;
    
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            block();
        });
    }
}

void YZPerformBlockSyncOnMainThread(void (^ _Nonnull block)(void))
{
    if (!block) return;
    
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            block();
        });
    }
}

void YZPerformBlockOnThread(void (^ _Nonnull block)(void), NSThread *thread)
{
    [YZUtility performBlock:block onThread:thread];
}

void YZSwizzleInstanceMethod(Class className, SEL original, SEL replaced)
{
    Method originalMethod = class_getInstanceMethod(className, original);
    Method newMethod = class_getInstanceMethod(className, replaced);
    
    BOOL didAddMethod = class_addMethod(className, original, method_getImplementation(newMethod), method_getTypeEncoding(newMethod));
    if (didAddMethod) {
        class_replaceMethod(className, replaced, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, newMethod);
    }
}

void YZSwizzleInstanceMethodWithBlock(Class class, SEL original, id block, SEL replaced)
{
    Method originalMethod = class_getInstanceMethod(class, original);
    IMP implementation = imp_implementationWithBlock(block);
    
    class_addMethod(class, replaced, implementation, method_getTypeEncoding(originalMethod));
    Method newMethod = class_getInstanceMethod(class, replaced);
    method_exchangeImplementations(originalMethod, newMethod);
}

SEL YZSwizzledSelectorForSelector(SEL selector)
{
    return NSSelectorFromString([NSString stringWithFormat:@"yz_swizzle_%x_%@", arc4random(), NSStringFromSelector(selector)]);
}


@implementation YZUtility

+ (void)performBlock:(void (^)(void))block onThread:(NSThread *)thread
{
    if (!thread || !block) return;
    
    if ([NSThread currentThread] == thread) {
        block();
    } else {
        [self performSelector:@selector(_performBlock:)
                     onThread:thread
                   withObject:[block copy]
                waitUntilDone:NO];
    }
}

+ (void)_performBlock:(void (^)(void))block
{
    block();
}


+ (NSDictionary *)getEnvironment
{
    
    NSString *platform = @"iOS";
    NSString *sysVersion = [[UIDevice currentDevice] systemVersion] ?: @"";
        
    NSMutableDictionary *data = [NSMutableDictionary dictionaryWithDictionary:@{
                                    @"platform":platform,
                                    @"osName":platform, //osName is eaqual to platorm name in native
                                    @"osVersion":sysVersion,
                                    @"jsSDKersion":@"",
                                    @"appName":@"appName",
                                    @"appVersion":@"appVersion",
                                }];
    
    return data;
}

static BOOL gIsEnvironmentUsingDarkScheme = NO;

+ (NSDictionary *_Nonnull)getEnvironmentForJSContext
{
    NSDictionary* result = [self getEnvironment];
    gIsEnvironmentUsingDarkScheme = [result[@"scheme"] isEqualToString:@"dark"];
    return result;
}

+ (BOOL)isEnvironmentUsingDarkScheme
{
    return gIsEnvironmentUsingDarkScheme;
}


+ (id)objectFromJSON:(NSString *)json
{
    if ([json isEqualToString:@"{}"]) return @{}.mutableCopy;
    if ([json isEqualToString:@"[]"]) return @[].mutableCopy;
    return [self JSONObject:[json dataUsingEncoding:NSUTF8StringEncoding] error:nil];
}

+ (id _Nullable)convertContainerToImmutable:(id _Nullable)source
{
    if (source == nil) {
        return nil;
    }
    
    if ([source isKindOfClass:[NSArray class]]) {
        NSMutableArray* tmpArray = [[NSMutableArray alloc] init];
        for (id obj in source) {
            if (obj == nil) {
                continue;
            }
            [tmpArray addObject:[self convertContainerToImmutable:obj]];
        }
        id immutableArray = [NSArray arrayWithArray:tmpArray];
        return immutableArray ? immutableArray : tmpArray;
    }
    else if ([source isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary* tmpDictionary = [[NSMutableDictionary alloc] init];
        for (id key in [source keyEnumerator]) {
            tmpDictionary[key] = [self convertContainerToImmutable:[source objectForKey:key]];
        }
        id immutableDict = [NSDictionary dictionaryWithDictionary:tmpDictionary];
        return immutableDict ? immutableDict : tmpDictionary;
    }
    
    return source;
}

+ (id)JSONObject:(NSData*)data error:(NSError **)error
{
    if (!data) return nil;
    id jsonObj = nil;
    @try {
        jsonObj = [NSJSONSerialization JSONObjectWithData:data
                                                  options:NSJSONReadingAllowFragments | NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves
                                                    error:error];
    } @catch (NSException *exception) {
        if (error) {
            *error = [NSError errorWithDomain:@"JS_ERROR_DOMAIN" code:-1 userInfo:@{NSLocalizedDescriptionKey: [exception description]}];
        }
    }
    return jsonObj;
}

+ (NSString *)JSONString:(id)object
{
    if(!object) return nil;
    
    @try {
    
        NSError *error = nil;
        if ([object isKindOfClass:[NSArray class]] || [object isKindOfClass:[NSDictionary class]]) {
            NSData *data = [NSJSONSerialization dataWithJSONObject:object
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:&error];
            if (error) {
                NSLog(@"%@", [error description]);
                return nil;
            }
            
            return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        } else if ([object isKindOfClass:[NSString class]]) {
            NSArray *array = @[object];
            NSData *data = [NSJSONSerialization dataWithJSONObject:array
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:&error];
            if (error) {
                NSLog(@"%@", [error description]);
                return nil;
            }
            
            NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            if (string.length <= 4) {
                NSLog(@"json convert length less than 4 chars.");
                return nil;
            }
            
            return [string substringWithRange:NSMakeRange(2, string.length - 4)];
        } else {
            NSLog(@"object isn't avaliable class");
            return nil;
        }
        
    } @catch (NSException *exception) {
        return nil;
    }
}

+ (id)copyJSONObject:(id)object
{
    if ([object isKindOfClass:[NSArray class]]) {
        NSArray *array = (NSArray *)object;
        NSMutableArray *copyObjs = [NSMutableArray array];
        
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            id copyObj = [self copyJSONObject:obj];
            [copyObjs insertObject:copyObj atIndex:idx];
        }];
        
        return copyObjs;
    } else if ([object isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = (NSDictionary *)object;
        NSMutableDictionary *copyObjs = [NSMutableDictionary dictionary];
        
        [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            id copyObj = [self copyJSONObject:obj];
            [copyObjs setObject:copyObj forKey:key];
        }];
        
        return copyObjs;
    } else {
        return [object copy];
    }
}

+ (BOOL)isBlankString:(NSString *)string {
    
    if (string == nil || string == NULL || [string isKindOfClass:[NSNull class]]) {
        return true;
    }
    if (![string isKindOfClass:[NSString class]]) {
        return true;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
        return true;
    }
    
    return false;
}

+ (BOOL)isFileExist:(NSString *)filePath
{
    return [[NSFileManager defaultManager] fileExistsAtPath:filePath];
}

+ (NSString *)documentDirectory
{
    static NSString *docPath = nil;
    if (!docPath){
        docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    }
    return docPath;
}

+ (NSString *)cacheDirectory
{
    static NSString *cachePath = nil;
    if (!cachePath) {
        cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    }
    return cachePath;
}

+ (NSString *)libraryDirectory
{
    static NSString *libPath = nil;
    if (!libPath) {
        libPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject;
    }
    return libPath;
}


+ (NSString *)stringWithContentsOfFile:(NSString *)filePath
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSString *contents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
        if (contents) {
            return contents;
        }
    }
    return nil;
}

+ (NSString *)md5:(NSString *)string
{
    const char *str = string.UTF8String;
    if (str == NULL) {
        return nil;
    }
    
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), result);
    
    return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

+ (NSString *)uuidString
{
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    CFStringRef uuidStringRef= CFUUIDCreateString(NULL, uuidRef);
    NSString *uuid = [NSString stringWithString:(__bridge NSString *)uuidStringRef];
    CFRelease(uuidRef);
    CFRelease(uuidStringRef);
    
    return [uuid lowercaseString];
}

+ (NSDate *)dateStringToDate:(NSString *)dateString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date=[formatter dateFromString:dateString];
    return date;
}

+ (NSDate *)timeStringToDate:(NSString *)timeString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"HH:mm"];
    NSDate *date=[formatter dateFromString:timeString];
    return date;
}

+ (NSString *)dateToString:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *str = [dateFormatter stringFromDate:date];
    return str;
}

+ (NSString *)timeToString:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *str = [dateFormatter stringFromDate:date];
    return str;
}

+ (NSUInteger)getSubStringNumber:(NSString *_Nullable)string subString:(NSString *_Nullable)subString
{
    if([string length] ==0) {
        return 0;
    }
    if([subString length] ==0) {
        return 0;
    }
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:subString options:NSRegularExpressionCaseInsensitive error:&error];
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:string options:0 range:NSMakeRange(0, [string length])];
    return numberOfMatches;
    
}

+ (NSString *_Nullable)returnKeyType:(UIReturnKeyType)type
{
    NSString *typeStr = @"default";
    switch (type) {
        case UIReturnKeyDefault:
            typeStr = @"default";
            break;
        case UIReturnKeyGo:
            typeStr = @"go";
            break;
        case UIReturnKeyNext:
            typeStr = @"next";
            break;
        case UIReturnKeySearch:
            typeStr = @"search";
            break;
        case UIReturnKeySend:
            typeStr = @"send";
            break;
        case UIReturnKeyDone:
            typeStr = @"done";
            break;
            
        default:
            break;
    }
    return typeStr;
}


+ (NSDictionary *_Nonnull)dataToBase64Dict:(NSData *_Nullable)data
{
    NSMutableDictionary *dataDict = [NSMutableDictionary new];
    if(data){
        NSString *base64Encoded = [data base64EncodedStringWithOptions:0];
        [dataDict setObject:@"binary" forKey:@"@type"];
        [dataDict setObject:base64Encoded forKey:@"base64"];
    }
    
    return dataDict;
}

+ (NSData *_Nonnull)base64DictToData:(NSDictionary *_Nullable)base64Dict
{
    if([@"binary" isEqualToString:base64Dict[@"@type"]]){
        NSString *base64 = base64Dict[@"base64"];
        NSData *sendData = [[NSData alloc] initWithBase64EncodedString:base64 options:0];
        return sendData;
    }
    return nil;
}

+ (NSArray<NSString *> *)extractPropertyNamesOfJSValueObject:(JSValue *)jsvalue
{
    if (!jsvalue) {
        return nil;
    }
    
    NSMutableArray* allKeys = nil;
    
    JSContextRef contextRef = jsvalue.context.JSGlobalContextRef;
    if (![jsvalue isObject]) {
        YZAssert(NO, @"Invalid jsvalue for property enumeration.");
        return nil;
    }
    JSValueRef jsException = NULL;
    JSObjectRef instanceContextObjectRef = JSValueToObject(contextRef, jsvalue.JSValueRef, &jsException);
    if (jsException != NULL) {
        NSLog(@"JSValueToObject Exception during create instance.");
    }
    BOOL somethingWrong = NO;
    if (instanceContextObjectRef != NULL) {
        JSPropertyNameArrayRef allKeyRefs = JSObjectCopyPropertyNames(contextRef, instanceContextObjectRef);
        size_t keyCount = JSPropertyNameArrayGetCount(allKeyRefs);
        
        allKeys = [[NSMutableArray alloc] initWithCapacity:keyCount];
        for (size_t i = 0; i < keyCount; i ++) {
            JSStringRef nameRef = JSPropertyNameArrayGetNameAtIndex(allKeyRefs, i);
            size_t len = JSStringGetMaximumUTF8CStringSize(nameRef);
            if (len > 1024) {
                somethingWrong = YES;
                break;
            }
            char* buf = (char*)malloc(len + 5);
            if (buf == NULL) {
                somethingWrong = YES;
                break;
            }
            bzero(buf, len + 5);
            if (JSStringGetUTF8CString(nameRef, buf, len + 5) > 0) {
                NSString* keyString = [NSString stringWithUTF8String:buf];
                if ([keyString length] == 0) {
                    somethingWrong = YES;
                    free(buf);
                    break;
                }
                [allKeys addObject:keyString];
            }
            else {
                somethingWrong = YES;
                free(buf);
                break;
            }
            free(buf);
        }
        JSPropertyNameArrayRelease(allKeyRefs);
    } else {
        somethingWrong = YES;
    }
    
    if (somethingWrong) {
        // may contain retain-cycle.
        allKeys = (NSMutableArray*)[[jsvalue toDictionary] allKeys];
    }
    
    return allKeys;
}

+ (id)parseValue:(JSValue *)value {
    NSString *content = @"js_data";
    if ([value isArray]) {
        return @{content:[value toArray]};
    } else if ([value isObject]) {
        return @{content:[value toObject]};
    } else if ([value isDate]) {
        return @{content:[value toDate]};
    } else if ([value isNull]) {
        return nil;
    } else if ([value isNumber]) {
        return @{content:[value toNumber]};
    } else if ([value isString]) {
        return @{content:[value toString]};
    } else if ([value isBoolean]) {
        return @{content:[value toNumber]};
    } else {
        return [value toDictionary];
    }
}

@end
