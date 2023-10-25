//
//  RTCUtils.swift
//  ComeSocialRTCService
//
//  Created by fuhao on 2023/1/13.
//

import Foundation
import AgoraRtcKit
import CoreMedia
import AVFoundation

class RTCUtils {
    internal static let shared = RTCUtils()
    
    struct RTCVideoDimension {
        let dimension: CGSize
        let aspectRatio : Float

        init(dimension: CGSize) {
            self.dimension = dimension
            aspectRatio = Float(dimension.width / dimension.height)
        }
    }
    
    let videoDimensionPreset: [RTCVideoDimension] = [ RTCVideoDimension(dimension: CGSize(width: 120, height: 120)),
                                                      RTCVideoDimension(dimension: CGSize(width: 160, height: 120)),
                                                      RTCVideoDimension(dimension: CGSize(width: 180, height: 180)),
                                                      RTCVideoDimension(dimension: CGSize(width: 240, height: 180)),
                                                      RTCVideoDimension(dimension: CGSize(width: 240, height: 240)),
                                                      RTCVideoDimension(dimension: CGSize(width: 320, height: 240)),
                                                      RTCVideoDimension(dimension: CGSize(width: 424, height: 240)),
                                                      RTCVideoDimension(dimension: CGSize(width: 360, height: 360)),
                                                      RTCVideoDimension(dimension: CGSize(width: 480, height: 360)),
                                                      RTCVideoDimension(dimension: CGSize(width: 640, height: 360)),
                                                      RTCVideoDimension(dimension: CGSize(width: 480, height: 480)),
                                                      RTCVideoDimension(dimension: CGSize(width: 640, height: 480)),
                                                      RTCVideoDimension(dimension: CGSize(width: 840, height: 480)),
                                                      RTCVideoDimension(dimension: CGSize(width: 960, height: 720)),
                                                      RTCVideoDimension(dimension: CGSize(width: 1280, height: 720)),
                                                      RTCVideoDimension(dimension: CGSize(width: 1920, height: 1080)),
                                                      RTCVideoDimension(dimension: CGSize(width: 2540, height: 1440)),
                                                      RTCVideoDimension(dimension: CGSize(width: 3840, height: 2160)) ]
    
    //匹配合适的分辨率
    internal func mathcVideoDimension(width: Int, height: Int) -> CGSize {
        let aspectRatio = Float(width) / Float(height)
        
        let nearestVideoDimensionPreset = videoDimensionPreset.sorted(by: {(obj1, obj2) -> Bool in
            return fabsf(obj1.aspectRatio - aspectRatio) < fabsf(obj2.aspectRatio - aspectRatio)
        })
        
        let chooseRatio = nearestVideoDimensionPreset[0].aspectRatio
        let satifyRotioDimensionPreset = nearestVideoDimensionPreset.filter { dimesion in
            (dimesion.aspectRatio - chooseRatio) < 0.0001 && (dimesion.aspectRatio - chooseRatio) > -0.0001
        }
        
        let results = satifyRotioDimensionPreset.sorted { obj1, obj2 in
            (abs(Int(obj1.dimension.width) - width) + abs(Int(obj1.dimension.height) - height)) < abs(Int(obj2.dimension.width) - width) + abs(Int(obj2.dimension.height) - height)
        }
        
        return results[0].dimension
    }
    
    
    
    //频道媒体信息配置
    internal func createChannelMediaOptions(role: AgoraClientRole) -> AgoraRtcChannelMediaOptions {
        let mediaOptions = AgoraRtcChannelMediaOptions()
        mediaOptions.publishCustomVideoTrack = true
        mediaOptions.publishCustomAudioTrack = true
        //TODO: 隐患，数据默认订阅了
        mediaOptions.autoSubscribeVideo = true
        mediaOptions.autoSubscribeAudio = true
        mediaOptions.clientRoleType = role
        return mediaOptions
    }
    
    // 创建声网的会话
    internal func createAgoraKit(defaultSettingAudioConfig: AudioConfiguration, defaultSettingVideoConfig: AgoraVideoEncoderConfiguration?, audioFrameDelegate: AgoraAudioFrameDelegate, videoFrameDelegate: AgoraVideoFrameDelegate, engineDelegate: AgoraRtcEngineDelegate) -> AgoraRtcEngineKit {
        
        let config = AgoraRtcEngineConfig()
        config.appId = KeyCenter.AppId
        config.areaCode = .CN
        config.channelProfile = .liveBroadcasting
        
        let agoraKit = AgoraRtcEngineKit.sharedEngine(with: config, delegate: engineDelegate)
        
#if DEBUG
        //设置log
        //agoraKit.setLogFile(LogUtils.sdkLogPath())
#endif
        
        
        
        //开启音频模块
        agoraKit.enableAudio()
        /**
         设置音频路由
         在频道中调用 disableVideo、enableLocalVideo、muteLocalVideoStream 或 muteAllRemoteVideoStreams 等方法关闭视频，则音频路由会自动切换到音频 SDK 默认的音频路由。
         通信场景    直播场景
         听筒            扬声器
         扬声器        扬声器
         https://docs.agora.io/cn/voice-legacy/set_audio_route_ios?platform=iOS
         */
//        agoraKit.setDefaultAudioRouteToSpeakerphone(true)
        
        //指定音频采集方式
        let sampleRate = defaultSettingAudioConfig.sampleRate
        let channel = defaultSettingAudioConfig.channelsPerFrame
        agoraKit.enableLocalAudio(false)
        
//        agoraKit.setPlaybackAudioFrameParametersWithSampleRate(Int(sampleRate), channel: Int(channel), mode: .readOnly, samplesPerCall: Int(sampleRate*channel)/100)
        
//        agoraKit.adjustPlaybackSignalVolume(0)
        agoraKit.setExternalAudioSource(true, sampleRate: sampleRate, channels: channel, sourceNumber: 1, localPlayback: false, publish: true)
        agoraKit.enableCustomAudioLocalPlayback(0, enabled: false)
        agoraKit.setAudioFrameDelegate(audioFrameDelegate)
//        agoraKit.enableCustomAudioLocalPlayback(1, enabled: false)
//        agoraKit.setParameters("{\"che.audio.external_render\": true}")
//        agoraKit.setParameters("{\"che.audio.keep.audiosession\": true}")
        
        
        if let defaultSettingVideoConfig = defaultSettingVideoConfig {
            //开启视频模块
            agoraKit.enableVideo()
            //指定视频采集方式
            agoraKit.setExternalVideoSource(true, useTexture: true, sourceType: .videoFrame)
            agoraKit.setVideoFrameDelegate(videoFrameDelegate)
            agoraKit.enableLocalVideo(false)
            //指定视频编码方式
            agoraKit.setVideoEncoderConfiguration(defaultSettingVideoConfig)
        }else {
            agoraKit.disableVideo()
        }
        
        agoraKit.setAudioSessionOperationRestriction(.all)
        
        
        

        return agoraKit
    }
    
//    func createCMSampleBufferFromPCM(pcmData: Data, format: AVAudioFormat) -> CMSampleBuffer? {
//        // 创建 AudioStreamBasicDescription 对象
//        let streamDesc = format.streamDescription.pointee
//        var audioDesc = AudioStreamBasicDescription(mSampleRate: streamDesc.mSampleRate,
//                                                    mFormatID: streamDesc.mFormatID,
//                                                    mFormatFlags: streamDesc.mFormatFlags,
//                                                    mBytesPerPacket: streamDesc.mBytesPerPacket,
//                                                    mFramesPerPacket: streamDesc.mFramesPerPacket,
//                                                    mBytesPerFrame: streamDesc.mBytesPerFrame,
//                                                    mChannelsPerFrame: streamDesc.mChannelsPerFrame,
//                                                    mBitsPerChannel: streamDesc.mBitsPerChannel,
//                                                    mReserved: 0)
//
//        // 创建 CMFormatDescription
//        var formatDesc: CMFormatDescription?
//        let status = CMAudioFormatDescriptionCreate(allocator: kCFAllocatorDefault, asbd: &audioDesc, layoutSize: 0, layout: nil, magicCookieSize: 0, magicCookie: nil, extensions: nil, formatDescriptionOut: &formatDesc)
//        guard status == noErr else { return nil }
//
//        // 将 PCM 数据包装成 CMBlockBuffer
//        var blockBuffer: CMBlockBuffer?
//        let blockBufferStatus = CMBlockBufferCreateWithMemoryBlock(allocator: kCFAllocatorDefault, memoryBlock: UnsafeMutableRawPointer(mutating: (pcmData as NSData).bytes), blockLength: pcmData.count, blockAllocator: kCFAllocatorNull, customBlockSource: nil, offsetToData: 0, dataLength: pcmData.count, flags: 0, blockBufferOut: &blockBuffer)
//        guard blockBufferStatus == noErr else {
//            return nil
//        }
//
//        // 创建 CMSampleTimingInfo 对象
//        var packetDescription = AudioStreamPacketDescription()
//
//        // 创建 CMSampleBuffer
//        var sampleBuffer: CMSampleBuffer?
//
//
//        let sampleBufferStatus = CMAudioSampleBufferCreateReadyWithPacketDescriptions(allocator: kCFAllocatorDefault, dataBuffer: blockBuffer!, formatDescription: formatDesc!, sampleCount: 1, presentationTimeStamp: CMTime.zero, packetDescriptions: &packetDescription, sampleBufferOut: &sampleBuffer)
//
//        guard sampleBufferStatus == noErr else {
//            return nil
//        }
//
//        return sampleBuffer
//    }
//
//
//    internal func convertPCMToSampleBuffer(pcmData: UnsafeMutablePointer<UInt8>!, sampleRate: Int, channel: Int, numFrames: Int) -> CMSampleBuffer? {
//        guard let audioFormat = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: Double(sampleRate), channels: AVAudioChannelCount(channel), interleaved: false) else {
//            return nil
//        }
//        // 创建一个 AVAudioPCMBuffer
//        let frameCapacity = AVAudioFrameCount(numFrames)
//        let pcmBuffer = AVAudioPCMBuffer(pcmFormat: audioFormat, frameCapacity: frameCapacity)!
//        pcmBuffer.frameLength = frameCapacity
//
//        // 获取可变的音频缓冲区列表
//        let audioBufferList = pcmBuffer.mutableAudioBufferList
//
//        var byteOffset = 0
//        // 将 UInt8 数据写入音频缓冲区列表
//        for bufferIndex in 0..<Int(audioBufferList.pointee.mNumberBuffers) {
//            let audioBuffer = audioBufferList.advanced(by: bufferIndex).pointee.mBuffers
//            let byteCount = Int(audioBuffer.mDataByteSize)
//            let destination = audioBuffer.mData?.assumingMemoryBound(to: UInt8.self)
//            let source = pcmData.advanced(by: byteOffset)
//            memcpy(destination, source, byteCount)
//            byteOffset += byteCount
//        }
//
//
//        return configureSampleBuffer(pcmBuffer: pcmBuffer)
//    }
//
//    func configureSampleBuffer(pcmBuffer: AVAudioPCMBuffer) -> CMSampleBuffer? {
//        let audioBufferList = pcmBuffer.mutableAudioBufferList
//        let asbd = pcmBuffer.format.streamDescription
//
//        var sampleBuffer: CMSampleBuffer? = nil
//        var format: CMFormatDescription? = nil
//
//        var status = CMAudioFormatDescriptionCreate(allocator: kCFAllocatorDefault,
//                                                         asbd: asbd,
//                                                   layoutSize: 0,
//                                                       layout: nil,
//                                                       magicCookieSize: 0,
//                                                       magicCookie: nil,
//                                                       extensions: nil,
//                                                       formatDescriptionOut: &format);
//        if (status != noErr) { return nil; }
//
//        var timing: CMSampleTimingInfo = CMSampleTimingInfo(duration: CMTime(value: 1, timescale: Int32(asbd.pointee.mSampleRate)),
//                                                            presentationTimeStamp: CMClockGetTime(CMClockGetHostTimeClock()),
//                                                            decodeTimeStamp: CMTime.invalid)
//        status = CMSampleBufferCreate(allocator: kCFAllocatorDefault,
//                                      dataBuffer: nil,
//                                      dataReady: false,
//                                      makeDataReadyCallback: nil,
//                                      refcon: nil,
//                                      formatDescription: format,
//                                      sampleCount: CMItemCount(pcmBuffer.frameLength),
//                                      sampleTimingEntryCount: 1,
//                                      sampleTimingArray: &timing,
//                                      sampleSizeEntryCount: 0,
//                                      sampleSizeArray: nil,
//                                      sampleBufferOut: &sampleBuffer);
//        if (status != noErr) { NSLog("CMSampleBufferCreate returned error: \(status)"); return nil }
//
//        status = CMSampleBufferSetDataBufferFromAudioBufferList(sampleBuffer!,
//                                                                blockBufferAllocator: kCFAllocatorDefault,
//                                                                blockBufferMemoryAllocator: kCFAllocatorDefault,
//                                                                flags: 0,
//                                                                bufferList: audioBufferList);
//        if (status != noErr) { NSLog("CMSampleBufferSetDataBufferFromAudioBufferList returned error: \(status)"); return nil; }
//
//        return sampleBuffer
//    }
}
