

#import <Foundation/Foundation.h>

@interface YZModuleFactory : NSObject

/**
 * @abstract Returns the class of specific module
 *
 * @param name The module name
 *
 **/
+ (Class)classWithModuleName:(NSString *)name;

/**
 * @abstract Returns the instance method implemented by the module 
 *
 * @param name The module name
 *
 * @param method The module method
 *
 **/
+ (SEL)selectorWithModuleName:(NSString *)name methodName:(NSString *)method isSync:(BOOL *)isSync;

/**
 * @abstract Registers a module for a given name and the implemented class
 *
 * @param name The module name to register
 *
 * @param clazz The module class to register
 *
 **/
+ (NSString *)registerModule:(NSString *)name withClass:(Class)clazz;

/**
 * @abstract Returns the export methods in the specific module
 *
 * @param name The module name
 **/
+ (NSMutableDictionary *)moduleMethodMapsWithName:(NSString *)name;

/**
 * @abstract Returns the export Selector in the specific module
 *
 * @param name The Selector name
 **/
+ (NSMutableDictionary *)moduleSelectorMapsWithName:(NSString *)name;

/**
 * @abstract Returns the registered modules.
 */
+ (NSDictionary *) moduleConfigs;
       
@end

