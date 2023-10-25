//
//  RTCChannel.swift
//  ComeSocialRTCService
//
//  Created by fuhao on 2022/12/21.
//

import Foundation
import AgoraRtcKit
import AVFoundation


internal protocol RTCChannelDelegate : AnyObject{
    func pushVideoFrame(buffer: CVPixelBuffer, trackId: UInt, rotation: Int)
    func pushPcmData(channel: RTCChannel,data: UnsafeMutablePointer<UInt8>, dataSize: Int,trackId: Int)
    func pushPcmData(channel: RTCChannel,data: AVAudioPCMBuffer, trackId: Int)
    func onJoinedChannel(channel: RTCChannel?)
    func onLeaveChannel(channel: RTCChannel,leaveUserAgoraId: UInt)
}


//协议声明
public typealias OnUsersJoin = ([RTCRemoteUser]?,RTCError?) -> Void
public typealias OnUsersLeave = ([RTCRemoteUser]?,RTCError?) -> Void


//频道参数
public struct RTCChannelParams {
    //是否接受频道内其他人的视频流
    var subscriptionVideo: Bool = true
    //是否接受频道内其他人的音频流
    var subscriptionAudio: Bool = true
    
    //编码配置
    var defaultVideoEncoderConfig: AgoraVideoEncoderConfiguration?
    
    var audioCaptureConfig: AudioConfiguration?
}

//频道信息
internal struct ChannelProfile {
    //频道ID，暂时同时应用于业务字段和声网频道ID
    var channelId: String
    
    //抽象远程用户
    var remoteUsers: [RTCRemoteUser]
    
    //RTC参数
    var channelParam: RTCChannelParams
    
    //连接用于连接声网的数据，通过访问业务服务器获得
    var agoraModel: AgoraParameter
}


//MARK: - 频道
public class RTCChannel : NSObject{
    weak var delegate: RTCChannelDelegate?
    let agoraId: UInt
    var channelProfile: ChannelProfile
    let audioManager = RTCAudioMananger()
    
    
    //MARK: - 协议 alise
    var onUsersJoin: OnUsersJoin?
    var onUsersLeave: OnUsersLeave?

    
    init(uid: UInt,delegate: RTCChannelDelegate,channelProfile: ChannelProfile) {
        print("RTCChannel: \(uid) 构造")
        self.agoraId = uid
        self.delegate = delegate
        self.channelProfile = channelProfile
    }
    
    deinit{
        print("RTCChannel: \(agoraId) 释放")
    }
    
    
    public func popRemoteUserByUID(uid: UInt) -> RTCRemoteUser? {
        guard let index = channelProfile.remoteUsers.firstIndex(where: {$0.getAgoraID() == uid}) else {
            return nil
        }
        let leaveUser = channelProfile.remoteUsers.remove(at: index)
        if leaveUser.getAgoraID() == uid {
            return leaveUser
        }else{
            channelProfile.remoteUsers.append(leaveUser)
            return nil
        }
    }
}

//MARK: - API
extension RTCChannel {
    public func getUID() -> UInt {
        return agoraId
    }
    
    //根据声网id获取远程用户
    public func getRemoteUserByUID(uid: UInt) -> RTCRemoteUser {
        guard let rtcRemoteUser = channelProfile.remoteUsers.first(where: {$0.getAgoraID() == uid}) else {
            let newRtcRemoteUser = RTCRemoteUser(uid: uid)
            channelProfile.remoteUsers.append(newRtcRemoteUser)
            return newRtcRemoteUser
        }
        
        return rtcRemoteUser
    }
    
    // 绑定监听用户进入事件
    public func onUsersJoin(onUserJoin: OnUsersJoin?) {
        self.onUsersJoin = onUserJoin
    }
    
    // 绑定监听用户离开事件
    public func onUsersLeave(onUserLeave: OnUsersLeave?) {
        self.onUsersLeave = onUserLeave
    }
    

    //传输视频数据
    public func sendVideoFrame(pixelBuffer: CVPixelBuffer, rotation: Int) {
        delegate?.pushVideoFrame(buffer: pixelBuffer, trackId: 0, rotation: rotation)
    }

    //传输音频数据
    public func sendAudioFrame(data: UnsafeMutablePointer<UInt8>, dataSize: Int){
        delegate?.pushPcmData(channel: self, data: data, dataSize: dataSize, trackId: 0)
    }
    
    //传输音频数据
    public func sendAudioFrame(data: AVAudioPCMBuffer){
        delegate?.pushPcmData(channel: self, data: data, trackId: 0)
    }
    
    //获取整个频道混音后的数据
    public func captureChannelAudioFrame(onAudioFrameCall: OnAudioFrameCall?) {
        audioManager.captureChannelAudioFrame(onAudioFrameCall: onAudioFrameCall)
    }
}

//MARK: - 声网数据回调
extension RTCChannel : AgoraRtcEngineDelegate {
    public func rtcEngine(_ engine: AgoraRtcEngineKit, didOccurWarning warningCode: AgoraWarningCode) {
        print("warning: \(warningCode.rawValue)")
    }

    public func rtcEngine(_ engine: AgoraRtcEngineKit, didOccurError errorCode: AgoraErrorCode) {
        print("Error: \(errorCode.rawValue) occur")
        delegate?.onJoinedChannel(channel: nil)
    }

    //加入频道成功
    public func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinChannel channel: String, withUid uid: UInt, elapsed: Int) {
        print("info:Join \(channel) with uid \(uid) elapsed \(elapsed)ms")
        
        //通知
        delegate?.onJoinedChannel(channel: self)
    }

    //有其他玩家加入
    public func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        //新增远程用户
        let joinUser = getRemoteUserByUID(uid: uid)
        //通知
        if let onUsersJoin = onUsersJoin {
            onUsersJoin([joinUser], nil)
        }
        
    }


    //有其他玩家离开
    public func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid: UInt, reason: AgoraUserOfflineReason) {
        if  let leaveUser = popRemoteUserByUID(uid: uid),
            let onUsersLeave = onUsersLeave {
            onUsersLeave([leaveUser], nil)
        }
    }
}
