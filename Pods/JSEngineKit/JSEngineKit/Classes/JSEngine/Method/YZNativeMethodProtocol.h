
#import "YZJSEngineProtocol.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * @abstract The callback after executing navigator operations. The code has some status such as 'WX_SUCCESS'、'WX_FAILED' etc. The responseData
 * contains some useful info you can handle.
 */
typedef void (^WXNavigationResultBlock)(NSString *code, NSDictionary * responseData);

@protocol YZNativeMethodProtocol

/**
 * @param data The target data.
 */
- (void)renderWidgetWithJSRender:(NSString *)instanceId data:(NSDictionary *)data;

/**
 *  @brief 更新room 信息
 */
- (void)updateRoomInfo:(NSString *)instanceId data:(NSDictionary *)data;

/**
 *  @brief 参加者进入条件
 */
- (void)enterRoomSetUp:(NSString *)instanceId data:(NSDictionary *)data;

/**
 *  @brief 添加视频滤镜
 */
- (void)applyVideoEffectFilter:(NSString *)instanceId data:(NSDictionary *)data;

/**
 *  @brief 开启视频采集
 */
- (void)startVideoCapture:(NSString *)instanceId data:(NSDictionary *)data;

/**
 *  @brief 停止视频采集
 */
- (void)stopVideoCapture:(NSString *)instanceId data:(NSDictionary *)data;

/**
 *  @brief 切换前后摄像头
 */
- (void)switchCameraSource:(NSString *)instanceId data:(NSDictionary *)data;

/**
 *  @brief 获取当前视图摄像头状态 是否打开，前摄像头打开还是后摄像头打开
 */
- (NSDictionary *)getCurrentCameraStatus:(NSString *)instanceId data:(NSDictionary *)data;

/**
 *  @brief 获取当前施加者麦克风状态
 */
- (NSDictionary *)getCurrentMicrophoneStatus:(NSString *)instanceId data:(NSDictionary *)data;

/**
 *  @brief 开启音频采集
 */
- (void)startAudioCapture:(NSString *)instanceId data:(NSDictionary *)data;

/**
 *  @brief 停止音频采集
 */
- (void)stopAudioCapture:(NSString *)instanceId data:(NSDictionary *)data;

/**
 *  @brief 添加视频面具
 */
- (void)applyVideoAvatar:(NSString *)instanceId data:(NSDictionary *)data;


/**
 *  @brief 添加音频滤镜
 */
- (void)applyAudioFilter:(NSString *)instanceId data:(NSDictionary *)data;

/**
 * @brief 禁言
 */
- (void)silence:(NSString *)instanceId data:(NSDictionary *)data;

/**
 * @brief 获取施加者对象信息
 */
- (NSDictionary *)getCurrentUserInfo:(NSString *)instanceId data:(NSDictionary *)data;

/**
 * @brief 上传照片信息
 */
- (void)uploadPhoto:(NSString *)instanceId data:(NSDictionary *)data;

/**
 * @brief 拍照自动更新
 */
- (void)takePhoto:(NSString *)instanceId data:(NSDictionary *)data;

/**
 * @brief alert message
 */
- (void)alertAction:(NSString *)instanceId data:(NSDictionary *)data;

/**
 * @brief broadcast
 */
- (void)brodcastAction:(NSString *)instanceId data:(NSDictionary *)data;

@end

NS_ASSUME_NONNULL_END
