//
//  YZNativeMethodManager.m
//  JSEngineKit
//
//  Created by li on 2023/2/9.
//

#import "YZNativeMethodManager.h"
#import "YZJSMethodDefine.h"
#import "YZNativeMethodProtocol.h"
@implementation YZNativeMethodManager


+ (id<YZNativeMethodProtocol>)handerForProtocol:(NSDictionary *)providers
{
    return [providers objectForKey:NSStringFromProtocol(@protocol(YZNativeMethodProtocol))];
}

+ (void)registerNativeFunctions:(YZJSEngineContext *)context provider:(NSDictionary *)providers
{
    [context registerHandler:YZRenderWidgetMethond withBlock:^id _Nullable(NSString * _Nonnull instanceId, NSString * _Nonnull eventName, NSDictionary * _Nonnull options) {
        [[YZNativeMethodManager handerForProtocol:providers] renderWidgetWithJSRender:instanceId data:options];
        return nil;
    }];
    
    [context registerHandler:YZUpdateRoomMethond withBlock:^id(NSString * _Nonnull instanceId, NSString * _Nonnull eventName, NSDictionary * _Nonnull options) {
        [[YZNativeMethodManager handerForProtocol:providers] updateRoomInfo:instanceId data:options];
        return nil;
    }];
    
    [context registerHandler:YZEnterGestureMethond withBlock:^id(NSString * _Nonnull instanceId, NSString * _Nonnull eventName, NSDictionary * _Nonnull options) {
        [[YZNativeMethodManager handerForProtocol:providers] enterRoomSetUp:instanceId data:options];
        return nil;
    }];
    
    [context registerHandler:YZParticipatingMembersMethond withBlock:^id(NSString * _Nonnull instanceId, NSString * _Nonnull eventName, NSDictionary * _Nonnull options) {
        [[YZNativeMethodManager handerForProtocol:providers] enterRoomSetUp:instanceId data:options];
        return nil;
    }];
    
    [context registerHandler:YZStartVideoCaptureMethond withBlock:^id(NSString * _Nonnull instanceId, NSString * _Nonnull eventName, NSDictionary * _Nonnull options) {
        [[YZNativeMethodManager handerForProtocol:providers] startVideoCapture:instanceId data:options];
        return nil;
    }];
    
    [context registerHandler:YZStopVideoCaptureMethond withBlock:^id(NSString * _Nonnull instanceId, NSString * _Nonnull eventName, NSDictionary * _Nonnull options) {
        [[YZNativeMethodManager handerForProtocol:providers] stopVideoCapture:instanceId data:options];
        return nil;
    }];
    
    [context registerHandler:YZStartAudioCaptureMethond withBlock:^id(NSString * _Nonnull instanceId, NSString * _Nonnull eventName, NSDictionary * _Nonnull options) {
        [[YZNativeMethodManager handerForProtocol:providers] startAudioCapture:instanceId data:options];
        return nil;
    }];
    
    [context registerHandler:YZStopAudioCaptureMethond withBlock:^id(NSString * _Nonnull instanceId, NSString * _Nonnull eventName, NSDictionary * _Nonnull options) {
        [[YZNativeMethodManager handerForProtocol:providers] stopAudioCapture:instanceId data:options];
        return nil;
    }];
    
    [context registerHandler:YZApplyAudioEffectFilterMethod withBlock:^id(NSString * _Nonnull instanceId, NSString * _Nonnull eventName, NSDictionary * _Nonnull options) {
        [[YZNativeMethodManager handerForProtocol:providers] applyAudioFilter:instanceId data:options];
        return nil;
    }];
    
    [context registerHandler:YZSwitchCameraSourceMethond withBlock:^id(NSString * _Nonnull instanceId, NSString * _Nonnull eventName, NSDictionary * _Nonnull options) {
        [[YZNativeMethodManager handerForProtocol:providers] switchCameraSource:instanceId data:options];
        return nil;
    }];
    
    [context registerHandler:YZApplyVideoEffectAvatarMethond withBlock:^id(NSString * _Nonnull instanceId, NSString * _Nonnull eventName, NSDictionary * _Nonnull options) {
        [[YZNativeMethodManager handerForProtocol:providers] applyVideoAvatar:instanceId data:options];
        return nil;
    }];
    
    [context registerHandler:YZApplyVideoEffectFilterMethond withBlock:^id(NSString * _Nonnull instanceId, NSString * _Nonnull eventName, NSDictionary * _Nonnull options) {
        [[YZNativeMethodManager handerForProtocol:providers] applyVideoEffectFilter:instanceId data:options];
        return nil;
    }];
    
    [context registerHandler:YZGetCurrentCameraStatusMethod withBlock:^id(NSString * _Nonnull instanceId, NSString * _Nonnull eventName, NSDictionary * _Nonnull options) {
        return [[YZNativeMethodManager handerForProtocol:providers] getCurrentCameraStatus:instanceId data:options];
    }];
    
    [context registerHandler:YZGetCurrentMicrophoneStatusMethod withBlock:^id(NSString * _Nonnull instanceId, NSString * _Nonnull eventName, NSDictionary * _Nonnull options) {
        [[YZNativeMethodManager handerForProtocol:providers] getCurrentMicrophoneStatus:instanceId data:options];
        return nil;
    }];
    
    [context registerHandler:YZAlertActionMethod withBlock:^id(NSString * _Nonnull instanceId, NSString * _Nonnull eventName, NSDictionary * _Nonnull options) {
        [[YZNativeMethodManager handerForProtocol:providers] alertAction:instanceId data:options];
        return nil;
    }];
    
    [context registerHandler:YZSilenceMethod withBlock:^id(NSString * _Nonnull instanceId, NSString * _Nonnull eventName, NSDictionary * _Nonnull options) {
        [[YZNativeMethodManager handerForProtocol:providers] silence:instanceId data:options];
        return nil;
    }];
    
    [context registerHandler:YZGetCurrentUserInfoMethod withBlock:^id(NSString * _Nonnull instanceId, NSString * _Nonnull eventName, NSDictionary * _Nonnull options) {
        return [[YZNativeMethodManager handerForProtocol:providers] getCurrentUserInfo:instanceId data:options];
    }];
    
    [context registerHandler:YZUploadPhotoMethod withBlock:^id _Nullable(NSString * _Nonnull instanceId, NSString * _Nonnull eventName, NSDictionary * _Nonnull options) {
        [[YZNativeMethodManager handerForProtocol:providers] uploadPhoto:instanceId data:options];
        return nil;
    }];
    
    [context registerHandler:YZTakePhotoMethod withBlock:^id _Nullable(NSString * _Nonnull instanceId, NSString * _Nonnull eventName, NSDictionary * _Nonnull options) {
        [[YZNativeMethodManager handerForProtocol:providers] takePhoto:instanceId data:options];
        return nil;
    }];
    
    
    [context registerHandler:YZBroadcastMethond withBlock:^id(NSString * _Nonnull instanceId, NSString * _Nonnull eventName, NSDictionary * _Nonnull options) {
        [[YZNativeMethodManager handerForProtocol:providers] brodcastAction:instanceId data:options];
        return nil;
    }];
    
}


@end
