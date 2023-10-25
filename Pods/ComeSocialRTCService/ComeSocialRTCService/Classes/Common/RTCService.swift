//
//  RTCService.swift
//  ComeSocialRTCService
//
//  Created by fuhao on 2023/1/3.
//

import Foundation
import AgoraRtcKit
import AVFoundation

public typealias OnJoinChannel = (RTCChannel?,RTCError?) -> Void
public typealias OnLeaveRoom = (RTCError?) -> Void


public struct AgoraParameter : Codable {
    var agoraId: UInt
    var channelName: String
    var token: String
    
    public init(agoraId: UInt, channelName: String, token: String) {
        self.agoraId = agoraId
        self.channelName = channelName
        self.token = token
    }
}

public enum RTCError: Error {
    case Sucess
    case AuthorizeFaild
    case Faild
}

public struct AudioConfiguration {
    //采样率
    var sampleRate: Int
    //通道数
    var channelsPerFrame: Int
    //采样位数
    var bitPerSample: Int
    //每次调用采样数
    var samplesPerCall: Int
}

//MARK: - RTC会话 管理音视频传输和消息
public class RTCService : NSObject{
    public static let shared = RTCService()
    
    

    //声网连接实例
    var agoraKit: AgoraRtcEngineKit?
    let date = Date()
    
    //预设设置视频信息
    var preSettingVideoConfig: AgoraVideoEncoderConfiguration? = AgoraVideoEncoderConfiguration(
        size: AgoraVideoDimension480x480,
        frameRate: .fps24,
        bitrate: AgoraVideoBitrateStandard,
        orientationMode: .adaptative,
        mirrorMode: .auto
    )
    
    //预设设置音频信息 连接之前设置
    var preSettingAudioConfig: AudioConfiguration = AudioConfiguration(
        sampleRate: 44100,
        channelsPerFrame: 1,
        bitPerSample: 16,
        samplesPerCall: 4410
    )
    
    //MARK: - 协议 alise
    var onLeaveRoom: OnLeaveRoom?
    var onJoinChannel: OnJoinChannel?

    
    
    
    
    var channels: [RTCChannel]?
    
    
    var _tempSize = 0
    
//    public func openDevelopeMode() {
//        AograNetService.openDeveloperMode()
//    }
    

}


//MARK: - Internal
extension RTCService {
    
    // 加入声网频道的实现
    // 加入对多频道的支持
    private func joinChannelImpl(channelProfile: ChannelProfile, onJoinChannel: OnJoinChannel?) {
        let channelId = channelProfile.channelId
        let agoraToken = channelProfile.agoraModel.token
        let uid = channelProfile.agoraModel.agoraId
        
        
        //初始化
        if channels == nil {
            let mainChannel = RTCChannel(uid: uid, delegate: self,channelProfile: channelProfile)
            channels = [RTCChannel]()
            channels?.append(mainChannel)
            if (agoraKit == nil){
                //AgoraAudioFrameDelegate
                //AgoraVideoFrameDelegate
                agoraKit = RTCUtils.shared.createAgoraKit(defaultSettingAudioConfig: preSettingAudioConfig, defaultSettingVideoConfig: preSettingVideoConfig, audioFrameDelegate: self, videoFrameDelegate: self, engineDelegate: mainChannel)
            }
        }
        
        //验证
        guard let agoraKit = agoraKit else {
            self.channels = nil
            onJoinChannel?(nil, nil)
            return
        }
        
        
        //频道媒体信息配置
        let mediaOptions = RTCUtils.shared.createChannelMediaOptions(role: .broadcaster)
        let result = agoraKit.joinChannel(byToken: agoraToken, channelId: channelId, uid: uid, mediaOptions: mediaOptions)
        if result != 0 {
            onJoinChannel?(nil,.Faild)
            // Usually happens with invalid parameters
            // Error code description can be found at:
            // en: https://api-ref.agora.io/en/voice-sdk/macos/3.x/Constants/AgoraErrorCode.html#content
            // cn: https://docs.agora.io/cn/Voice/API%20Reference/oc/Constants/AgoraErrorCode.html
            print("joinChannel call failed: \(result), please check your params")
            return
        }
        self.onJoinChannel = onJoinChannel
    }
    
    

    
    func closeAgora() {
        if let agoraKit = agoraKit {
            //1.断开声网
            agoraKit.disableAudio()
            agoraKit.disableVideo()
            let option = AgoraRtcChannelMediaOptions()
            option.publishCustomAudioTrack = false
            option.publishCustomVideoTrack = false
            agoraKit.updateChannel(with: option)
            agoraKit.leaveChannel { (stats) -> Void in
                //                LogUtils.log(message: "left channel, duration: \(stats.duration)", level: .info)
            }
            self.agoraKit = nil
        }
    }

}


//MARK: - API
extension RTCService {

    //设置传输的音频流数据
    public func setAudioPresetParam(sampleRate: Int, channel: Int, bitPerSample: Int, samplePerCall: Int) {
        preSettingAudioConfig = AudioConfiguration(
            sampleRate: sampleRate,
            channelsPerFrame: channel,
            bitPerSample: bitPerSample,
            samplesPerCall: samplePerCall
        )
    }
    
    //设置传输的视频流数据
    public func setVideoPresetParam(width: Int, height: Int, fps: Int = 24){
        guard let frameRate = AgoraVideoFrameRate(rawValue: fps) else {
            return
        }
        
        guard let agoraKit = agoraKit else {
            
            //存储预设值参数
            preSettingVideoConfig = AgoraVideoEncoderConfiguration(
                size: CGSize(width: width, height: height),
                frameRate: frameRate,
                bitrate: AgoraVideoBitrateStandard,
                orientationMode: .adaptative,
                mirrorMode: .auto
            )
            
            return
        }
        
        
        let dimension = RTCUtils.shared.mathcVideoDimension(width: width, height: height)
        let encoderConfig = AgoraVideoEncoderConfiguration(
            size: dimension,
            frameRate: frameRate,
            bitrate: AgoraVideoBitrateStandard,
            orientationMode: .adaptative,
            mirrorMode: .auto
        )
        
        preSettingVideoConfig = encoderConfig
        agoraKit.setVideoEncoderConfiguration(encoderConfig)
        
    }
    
    public func disableVideo() {
        preSettingVideoConfig = nil
    }
    

    
    
    // 加入频道
    public func joinChannel(param: AgoraParameter, onJoinChannel: OnJoinChannel?) {
        let channelProfile = ChannelProfile(channelId: param.channelName, remoteUsers: [RTCRemoteUser](), channelParam: RTCChannelParams(), agoraModel: param)
        joinChannelImpl(channelProfile: channelProfile,onJoinChannel: onJoinChannel)
    }
    

    // 离开频道
    public func leaveChannel(channel: RTCChannel, onLeaveRoom : OnLeaveRoom?) {
        guard let channels = channels else{
            closeAgora()
            onLeaveRoom?(nil)
            return
        }
        
        guard let mainChennel = channels.first else {
            self.channels = nil
            closeAgora()
            onLeaveRoom?(nil)
            return
        }
        
        
        //判断是否是主频道
        if mainChennel.getUID() == channel.getUID() {
            self.channels = nil
            closeAgora()
            onLeaveRoom?(nil)
            return
        }
        
        
        
        
        guard let channelIndex = channels.firstIndex(where: {$0.getUID() == channel.getUID()}) else {
            onLeaveRoom?(nil)
            return
        }
        
        self.channels?.remove(at: channelIndex)
        
        if let agoraKit = agoraKit {
            //TODO: - 移除子频道 channelIndex
        }
        
        onLeaveRoom?(nil)
        
        
    }
    
    
}




//MARK: - 音频帧观察
extension RTCService: AgoraAudioFrameDelegate {
    //设置观测的音频位置
    public func getObservedAudioFramePosition() -> AgoraAudioFramePosition {
        guard let channels = channels,
              let channel = channels.first else {
            return .playback
        }

        guard let onAudioFrameCall = channel.audioManager.onAudioFrameCall else{
            return .beforeMixing
        }
        return .playback
    }
    
    
    
    //设置远程用户音频格式
    public func getPlaybackAudioParams() -> AgoraAudioParams {
        return AgoraAudioParams()
    }
    
    //获取远程用户混音后的音频
    public func onPlaybackAudioFrame(_ frame: AgoraAudioFrame, channelId: String) -> Bool {
        guard let channels = channels else {
            return true
        }

        let filterChannels = channels.filter({ channel in
            channel.channelProfile.channelId == channelId
        })

        if filterChannels.count > 1 {
            fatalError("filterChannels is greater 1")
        }

        if let choiceChannel = filterChannels.first,
           let onAudioFrameCall = choiceChannel.audioManager.onAudioFrameCall{
            guard let buffer = frame.buffer else {
                return true
            }
            let bytesLength = frame.samplesPerChannel * frame.channels * frame.bytesPerSample
            let data: UnsafeMutablePointer<UInt8> = buffer.bindMemory(to: UInt8.self, capacity: bytesLength)
            
            choiceChannel.audioManager.pushAudioFrame(data: data, length: bytesLength)

        }
        
        return true
    }
    
    
    

    //设置耳返返回的音频格式
    public func getEarMonitoringAudioParams() -> AgoraAudioParams {
        AgoraAudioParams()
    }
    
    //设置混合后的音频格式
    public func getMixedAudioParams() -> AgoraAudioParams {
        let params = AgoraAudioParams()
        params.channel = 1
        params.mode = AgoraAudioRawFrameOperationMode.readOnly
        params.sampleRate = 44100
        params.samplesPerCall = 4410
        
        return params
    }
    
    //设置本地采集的音频格式
    public func getRecordAudioParams() -> AgoraAudioParams {
        AgoraAudioParams()
    }
    
    

    //获取本地采集的音频
    public func onRecordAudioFrame(_ frame: AgoraAudioFrame, channelId: String) -> Bool {
        true
    }
    
    //获取耳返的音频
    public func onEarMonitoringAudioFrame(_ frame: AgoraAudioFrame) -> Bool {
        true
    }

    //获取采集和播放音频混音后的数据
    public func onMixedAudioFrame(_ frame: AgoraAudioFrame, channelId: String) -> Bool {
        return true
    }
    

    
    //获取远程用户混音前的音频
    public func onPlaybackAudioFrame(beforeMixing frame: AgoraAudioFrame, channelId: String, uid: UInt) -> Bool {
        guard let channels = channels else {
            return true
        }
        
        let filterChannels = channels.filter({ channel in
            channel.channelProfile.channelId == channelId
        })
        
        if filterChannels.count > 1 {
            fatalError("filterChannels is greater 1")
        }
        

        if let choiceChannel = filterChannels.first {
            let remoteUser = choiceChannel.getRemoteUserByUID(uid: uid)
            guard let onAudioFrameCall = remoteUser.onAudioFrameCall else {
                return false
            }
            
            guard let buffer:UnsafeMutableRawPointer = frame.buffer else {
                return false
            }
            
            let bytesLength = frame.samplesPerChannel * frame.channels * frame.bytesPerSample
            let data: UnsafeMutablePointer<UInt8> = buffer.bindMemory(to: UInt8.self, capacity: bytesLength)
            
            remoteUser.pushAudioFrame(data: data, length: bytesLength)
        }
        
        return true
    }
}


//MARK: - 视频帧观察
extension RTCService : AgoraVideoFrameDelegate {
    //获取本地摄像头采集到的视频数据
    public func onCapture(_ videoFrame: AgoraOutputVideoFrame) -> Bool {
        return true
    }
    
    //远端发送的视频数据
    public func onRenderVideoFrame(_ videoFrame: AgoraOutputVideoFrame, uid: UInt, channelId: String) -> Bool {
        guard let pixelBuffer = videoFrame.pixelBuffer else {
            return false
        }
        guard let rtcChannel = channels?.first(where: {$0.channelProfile.channelId == channelId}) else {
            return false
        }
        
        
//        print("rotation : \(videoFrame.rotation)")
        
        let rtcRemoteUser = rtcChannel.getRemoteUserByUID(uid: uid)
        rtcRemoteUser.pushVideoFrame(pixelBuffer: pixelBuffer,rotation: Int(videoFrame.rotation))
        return true
    }
    
    //仅读取
    public func getVideoFrameProcessMode() -> AgoraVideoFrameProcessMode {
        return .readOnly
    }
    
    
    //获取本地视频编码前的视频数据，没有用它的原因是在分流是无法单独处理
    public func onPreEncode(_ videoFrame: AgoraOutputVideoFrame) -> Bool {
        return true
    }
    
    //制定 SDK 输出的视频数据格式，根据编码原理YUV效率最高
    public func getVideoFormatPreference() -> AgoraVideoFormat {
        return .cvPixelNV12
    }
}



//MARK: - 频道 Delegate
extension RTCService : RTCChannelDelegate {
    func onLeaveChannel(channel: RTCChannel, leaveUserAgoraId: UInt) {
        
    }
    
    func onJoinedChannel(channel: RTCChannel?) {
        self.onJoinChannel?(channel,nil)
        self.onJoinChannel = nil
    }
    

    
    //推送音频流
    internal func pushPcmData(channel: RTCChannel,data: UnsafeMutablePointer<UInt8>, dataSize: Int,trackId: Int) {
        guard let agoraKit = agoraKit else {
            return
        }
        
        let sampleRate = preSettingAudioConfig.sampleRate
        let channel = preSettingAudioConfig.channelsPerFrame
        let sampleNum = (dataSize * 8) / (preSettingAudioConfig.bitPerSample)
        
        agoraKit.pushExternalAudioFrameRawData(data, samples: sampleNum, sampleRate: sampleRate, channels: channel, sourceId: trackId, timestamp: 0)
        
    }
    
    //推送音频流
    internal func pushPcmData(channel: RTCChannel,data: AVAudioPCMBuffer,trackId: Int) {
        guard let agoraKit = agoraKit else {
            return
        }
        let sampleNum = Int(data.frameLength)
        let frameByteSize = sampleNum << 1
        let channel = data.format.channelCount
        let sampleRate = data.format.sampleRate
        guard let channelData:UnsafePointer<UnsafeMutablePointer<Int16>> = data.int16ChannelData else {
            return
        }
        
        let result = channelData.pointee.withMemoryRebound(to: UInt8.self, capacity: frameByteSize) { pointer in
            agoraKit.pushExternalAudioFrameRawData(pointer, samples: sampleNum, sampleRate: Int(sampleRate), channels: Int(channel), sourceId: trackId, timestamp: 0)
        }
        
        
    }
    
    
    
    //推送视频流
    //trackId 用于多路推流
    internal func pushVideoFrame(buffer: CVPixelBuffer, trackId: UInt, rotation: Int) {
        guard let agoraKit = agoraKit else {
            return
        }

        let videoFrame = AgoraVideoFrame()

        
        /** Video format:
         * - 1: I420
         * - 2: BGRA
         * - 3: NV21
         * - 4: RGBA
         * - 5: IMC2
         * - 7: ARGB
         * - 8: NV12
         * - 12: iOS texture (CVPixelBufferRef)
         */
        videoFrame.format = 12
        videoFrame.textureBuf = buffer
        videoFrame.rotation = Int32(rotation)
        
        if(trackId > 0){
            agoraKit.pushExternalVideoFrame(videoFrame, videoTrackId: trackId)
        }else{
            agoraKit.pushExternalVideoFrame(videoFrame)
        }
    }
    

}
