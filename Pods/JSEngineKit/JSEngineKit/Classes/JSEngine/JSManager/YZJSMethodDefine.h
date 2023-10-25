//
//  YZJSMethodDefine.h
//  JSEngineKit
//
//  Created by li on 2023/1/18.
//


// instanceId
static const NSString *YZInstanceId = @"instanceId";

static NSString * const YZJsSettingsFucName = @"exportParameterSettings";
static NSString * const YZJsSetParameterSetingsFucName = @"$setParameterSettings";

static NSString * const YZStartVideoCaptureMethond = @"cs_startVideoCapture";
static NSString * const YZStopVideoCaptureMethond = @"cs_stopVideoCapture";
static NSString * const YZStartAudioCaptureMethond = @"cs_startAudioCapture";
static NSString * const YZStopAudioCaptureMethond = @"cs_stopAudioCapture";
static NSString * const YZSwitchCameraSourceMethond = @"cs_switchCameraSource";

static NSString * const YZApplyVideoEffectFilterMethond = @"cs_applyVideoEffectFilter";
static NSString * const YZApplyVideoEffectAvatarMethond = @"cs_applyVideoAvatar";
static NSString * const YZGetCurrentCameraStatusMethod = @"cs_getCurrentCameraStatus";

static NSString * const YZGetCurrentMicrophoneStatusMethod = @"cs_getCurrentMicrophoneStatusMethod";

static NSString * const YZSilenceMethod = @"cs_silence";

static NSString * const YZGetCurrentUserInfoMethod = @"cs_getCurrentUserInfo";

static NSString * const YZUpdateRoomMethond = @"cs_updateRoom";
static NSString * const YZParticipatingMembersMethond = @"cs_participatingMembers";
static NSString * const YZEnterGestureMethond = @"cs_enterGesture";
static NSString * const YZApplyAudioEffectFilterMethod = @"cs_applyAudioEffectFilter";

static NSString * const YZUploadPhotoMethod = @"cs_uploadPhoto";
static NSString * const YZTakePhotoMethod = @"cs_takePhoto";
static NSString * const YZRenderWidgetMethond = @"cs_renderWidget";
static NSString * const YZAlertActionMethod = @"cs_showMessage";
static NSString * const YZBroadcastMethond = @"cs_broadcast";
static NSString * const YZApplyActionMethond = @"applyAction";

static NSString * const YZBindingShowCameraButtonMethond = @"cameraButtonControl";
static NSString * const YZBindingMicrophoneButtonMethond = @"microphoneButtonControl";



/*
 * Concatenate preprocessor tokens a and b without expanding macro definitions
 * (however, if invoked from a macro, macro arguments are expanded).
 */
#define YZ_CONCAT(a, b)   a ## b
/*
 * Concatenate preprocessor tokens a and b after macro-expanding them.
 */
#define YZ_CONCAT_WRAPPER(a, b)    YZ_CONCAT(a, b)

#define YZ_EXPORT_METHOD_INTERNAL(method, token) \
+ (NSString *)YZ_CONCAT_WRAPPER(token, __LINE__) { \
    return NSStringFromSelector(method); \
}

/**
 *  @abstract export public method
 */
#define YZ_EXPORT_METHOD(method) YZ_EXPORT_METHOD_INTERNAL(method,yz_export_method_)

/**
 *  @abstract export public method, support sync return value
 *  @warning the method can only be called on js thread
 */
#define YZ_EXPORT_METHOD_SYNC(method) YZ_EXPORT_METHOD_INTERNAL(method,yz_export_method_sync_)
