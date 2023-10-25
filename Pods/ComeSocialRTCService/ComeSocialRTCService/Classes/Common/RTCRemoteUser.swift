//
//  RTCRemoteUser.swift
//  ComeSocialRTCService
//
//  Created by fuhao on 2022/12/21.
//

import Foundation
import AVFAudio

public typealias OnVideoFrameCall = (_ data: CVPixelBuffer, _ rotation: Int) -> Void
public typealias OnAudioFrameCall = (_ data: AVAudioPCMBuffer) -> Void

//MARK: - 远程用户
public class RTCRemoteUser {
    let agoraId: UInt
    
    var onVideoFrameCall: OnVideoFrameCall?
    var onAudioFrameCall: OnAudioFrameCall?
    
    init(uid: UInt) {
        print("RTCRemoteUser: \(uid) 构造")
        self.agoraId = uid
    }
    
    deinit{
        print("RTCRemoteUser: \(agoraId) 释放")
    }
    
    // 获取用户ID
    public func getAgoraID() -> UInt {
        return agoraId
    }

}


//MARK: - API（也许是一些实物性的API，结合长连接协议封装，比如禁言，踢掉。。。）
extension RTCRemoteUser {
    //获取视频帧数据
    public func captureVideoFrame(onVideoFrameCall: OnVideoFrameCall?) {
        self.onVideoFrameCall = onVideoFrameCall
    }
    
    
    //不常用，获取单个远端用户音频数据
    public func captureAudioFrame(onAudioFrameCall: OnAudioFrameCall?) {
        self.onAudioFrameCall = onAudioFrameCall
        
        //TODO: - 更改音频帧监听的配置
    }
    
    

}



//MARK: - Internal
extension RTCRemoteUser {
    //从声网推送的数据
    internal func pushVideoFrame(pixelBuffer: CVPixelBuffer,rotation: Int) {
        guard let onVideoFrameCall = onVideoFrameCall else {
            return
        }
        onVideoFrameCall(pixelBuffer, rotation)
    }
    //从声网推送的数据
    internal func pushAudioFrame(data: UnsafeMutablePointer<UInt8>,  length: Int) {
        guard let onAudioFrameCall = onAudioFrameCall else {
            return
        }
        guard let pcmFormat = AVAudioFormat(commonFormat: .pcmFormatInt16, sampleRate: 44100, channels: 1, interleaved: false),
              let buffer = AVAudioPCMBuffer(pcmFormat: pcmFormat, frameCapacity: AVAudioFrameCount(length >> 1)) else {
            return
        }
        buffer.frameLength = buffer.frameCapacity


        var uint8Pointer: UnsafeMutablePointer<UInt8>?
        buffer.int16ChannelData?.pointee.withMemoryRebound(to: UInt8.self, capacity: length) { ptr in
            uint8Pointer = UnsafeMutablePointer<UInt8>(mutating: ptr)
        }

        guard let uint8Pointer = uint8Pointer else {
            return
        }
        
        memcpy(uint8Pointer, data, length)
        onAudioFrameCall(buffer)
    }
}
