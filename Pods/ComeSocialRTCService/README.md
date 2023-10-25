# ComeSocialRTCService

[![CI Status](https://img.shields.io/travis/7991282/ComeSocialRTCService.svg?style=flat)](https://travis-ci.org/7991282/ComeSocialRTCService)
[![Version](https://img.shields.io/cocoapods/v/ComeSocialRTCService.svg?style=flat)](https://cocoapods.org/pods/ComeSocialRTCService)
[![License](https://img.shields.io/cocoapods/l/ComeSocialRTCService.svg?style=flat)](https://cocoapods.org/pods/ComeSocialRTCService)
[![Platform](https://img.shields.io/cocoapods/p/ComeSocialRTCService.svg?style=flat)](https://cocoapods.org/pods/ComeSocialRTCService)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

ComeSocialRTCService is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
source 'git@github.com:NeoWorldTeam/ComeSocialSpecs.git'
pod 'ComeSocialRTCService'
```

## Tutorial

封装基于频道的音视频连接。

**RTCService，提供频道连接的单例**
```swift
//导入
import ComeSocialRTCService


/**
* RTCService 获取一个单例，提供以下方法
* 1. 设置频道连接的参数（可选）
* 2. 连接一个频道
**/
RTCService.shared


/**
* 设置发送的音频参数
* sampleRate 音频的采样率，默认44100
* channel 通道数，默认1
* bitPerSample 每个采样的位数，默认short 16位
* samplePerCall 每次发送传输的采样数，暂时没用
**/
public func setAudioPresetParam(sampleRate: Int, channel: Int, bitPerSample: Int, samplePerCall: Int)


/**
* 设置发送的视频参数
* width 设置视频宽度，默认480
* height 设置视频高度，可选480
* fps 传输视频的帧数，可选24
* 对于视频发送的分辨率的大小有一定要求，会进行一些匹配
**/
public func setVideoPresetParam(width: Int, height: Int, fps: Int = 24)



/**
* 连接一个频道
* userToken 业务上的用户 token
* channelId 业务上的频道的 id
* onJoinChannel 连接频道的回调，得到 RTCChannel 对象
* 请注意，可以同时连接多个频道
* 在没有连接任何频道时，调用频道连接，此时连接的为主频道
* 在已经有主频道连接的情况下，再次连接其他频道，都为子频道
* 当主频道被释放的时候，子频道会被自动释放。
**/
public func joinChannel(userToken: String, channelId: String, onJoinChannel: OnJoinChannel?)

/**
* 通过 UID 获取注册的远程用户
* uid 用户 UID
* 返回值 RTCRemoteUser
**/
public func getRemoteUserByUID(uid: UInt) -> RTCRemoteUser
```


**RTCChannel，连接的频道对象**

*发送数据*
将采集到的数据发送至频道
视频数据采集来源：
1. 访问 Cemera API 获取 CVPixelBuffer 发送
2. 访问 Render 对象，获取渲染结果 Texture，然后将结果通过 DataPipe 转换至 CVPixelBuffer 发送
3. 其他来源

音频数据的来源：
1. 访问系统麦克风接口，获取 pcm 数据发送，可以参考 Demo 内的 AudioCaptureNative
2. 解码音频资源，获取 pcm 数据发送
3. 获取多个不同音频来源的 pcm ，然后通过 DataPipe 将多个音频混音后得到 pcm 发送
4. 其他

```swift
//

/**
* 将音频数据传输给频道
* data pcm数据，格式遵从之前的设置
* dataSize 数据长度
**/
func sendAudioFrame(data: UnsafeMutablePointer<UInt8>, dataSize: Int)

/**
* 将视频数据传输给频道
* pixelBuffer 像素数据
**/
func sendVideoFrame(pixelBuffer: CVPixelBuffer)



/**
**已经废弃**
* 将数据发送给其他用户
* content 内容
* user 接收的远程用户
* SendToUser 回调的结果
* 已经废弃
**/
func sendToUser(content: String, user: RTCRemoteUser, sendToUser: SendToUser?)

/**
**已经废弃**
* 将数据广播给频道内所有用户
* content 内容
* SendToUser 回调的结果
**/
func broadcastToUsers(content: String, sendToUser: SendToUser?)

```

*监听频道*

```swift

/**
* 获取所有远程用户混音后的音频数据
* onVideoFrameCall 数据的回调
**/
func captureChannelAudioFrame(onAudioFrameCall: OnAudioFrameCall?)
请注意，这接口和单独监听某个用户声音一般不一起使用。


下面的接口，已经废弃，但还可以调用。之后主要通过长连接得到用户uid然后获取remoteuser

/**
* 监听有其他用户加入频道
* onUserJoin [RTCRemoteUser]?,RTCError? -> Void 
* RTCRemoteUser 远程用户的对象
**/
func func onUsersJoin(onUserJoin: OnUsersJoin?)


/**
* 监听有其他用户离开频道
* OnUsersLeave [RTCRemoteUser]?,RTCError? -> Void 
* RTCRemoteUser 远程用户的对象
**/
func onUsersLeave(onUserLeave: OnUsersLeave?)


/**
* 监听来自频道的消息
* onListnerMessageFromUser 消息内容的回调
**/
func onListnerMessageFromUser(onListnerMessageFromUser: OnListnerFromUser?)

/**
* 查询最新的远程用户列表
* onListnerMessageFromUser 消息内容的回调
* queryUserInChannel 消息回调
**/
func queryUsersInChannel(queryUserInChannel: QueryUsersInRoom?)
```

**RTCRemoteUser，远程用户**

```swift

/**
* 获取远程用户的视频数据
* onVideoFrameCall 数据的回调
**/
func captureVideoFrame(onVideoFrameCall: OnVideoFrameCall?)


/**
* 获取单个远程用户的音频数据
* onVideoFrameCall 数据的回调
**/
func captureAudioFrame(onAudioFrameCall: OnAudioFrameCall?)
如果需要单独对某个远程用户A的音频进行变音处理，可能的步骤是：
1. 有三个用户A，B，C，分别调用获取单个远程用户的音频数据
2. 建立数据管道，将A的音频数据传入变声Processer，然后将结果和B，C的音频数据一起传入Mix Processer进行混音，
3. 将混音后的结果，用本地音频渲染器出来 

```

渲染来自远程用户的数据
渲染音频数据，可以参考 Demo 内的 AudioRenderNative
渲染视频数据，可以参考 Demo 内的 MetalRenderer


## Author

7991282, fangshiyu2@gmail.com

## License

ComeSocialRTCService is available under the MIT license. See the LICENSE file for more info.