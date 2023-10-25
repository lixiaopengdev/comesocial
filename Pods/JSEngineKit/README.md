# JSEngineKit

[![CI Status](https://img.shields.io/travis/li/JSEngineKit.svg?style=flat)](https://travis-ci.org/li/JSEngineKit)
[![Version](https://img.shields.io/cocoapods/v/JSEngineKit.svg?style=flat)](https://cocoapods.org/pods/JSEngineKit)
[![License](https://img.shields.io/cocoapods/l/JSEngineKit.svg?style=flat)](https://cocoapods.org/pods/JSEngineKit)
[![Platform](https://img.shields.io/cocoapods/p/JSEngineKit.svg?style=flat)](https://cocoapods.org/pods/JSEngineKit)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

JSEngineKit is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'JSEngineKit'
```

```ruby

/**
 *  register Handler before 
 *  @param eventName  :   instance id
 *  @param block : call back block
 */
- (void)registerHandler:(NSString *)eventName withBlock:(YZJSCallNativeBlock)block;

/**
 *  Destroy Instance Method
 *  @param instanceId  :   instance id
 */
- (void)destroyInstance:(NSString *)instanceId;

/**
 *  execute Js Method
 *  @param instanceId : must contain instanceId
 *  @param args : call args
 */
- (void)callJSMethod:(NSString *)method
          instanceId:(NSString *)instanceId
                args:(NSArray * _Nullable)args;

/**
 *  execute Js Method with call back
 *  @param args :  call args
 *  @param instanceId : must contain instanceId
 *  @param completion : need call back
 */
- (void)callJSMethod:(NSString *)method
           instanceId:(NSString *)instanceId
                args:(NSArray * _Nullable)args
          completion:(void (^ _Nullable)(id data))completion;
          
/**
 *  Js Settings Method
 *  @param instanceId : instanceId
 *  @param filePath : js path
 */
- (NSDictionary *)getJsSettingsWithInstanceId:(NSString *)instanceId filePath:(NSString *)filePath;

/**
 *  execute Js Method
 *  @param instanceId :  instanceId
 *  @param dict :  set dict
 */
- (void)setJsSettingsWithInstanceId:(NSString *)instanceId dict:(NSDictionary *)dict;

```


## Author

li, xiaopeng.li@neoworld.cloud

## License

JSEngineKit is available under the MIT license. See the LICENSE file for more info.
