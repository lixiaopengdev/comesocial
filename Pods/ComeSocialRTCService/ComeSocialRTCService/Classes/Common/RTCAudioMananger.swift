//
//  RTCAudioMananger.swift
//  ComeSocialRTCService
//
//  Created by fuhao on 2023/1/19.
//

import Foundation
import AudioToolbox
import AVFoundation


class AudioMixer {
    private var audioGraph: AUGraph?
    private var mixerNode: AUNode = 0
    private var mixerUnit: AudioUnit?
    private var outputNode: AUNode = 0
    private var outputUnit: AudioUnit?
    
    init() {
        setupAudioGraph()
    }
    
    deinit {
        if let audioGraph = audioGraph {
            AUGraphUninitialize(audioGraph)
            AUGraphClose(audioGraph)
            DisposeAUGraph(audioGraph)
        }
    }
}

extension AudioMixer {
    private func setupAudioGraph() {
        NewAUGraph(&audioGraph)
        
        guard let audioGraph = audioGraph else {
            return
        }
        
        var mixerDescription = AudioComponentDescription()
        mixerDescription.componentType = kAudioUnitType_Mixer
        mixerDescription.componentSubType = kAudioUnitSubType_MultiChannelMixer
        mixerDescription.componentManufacturer = kAudioUnitManufacturer_Apple
        AUGraphAddNode(audioGraph, &mixerDescription, &mixerNode)
        
        var outputDescription = AudioComponentDescription()
        outputDescription.componentType = kAudioUnitType_Output
        outputDescription.componentSubType = kAudioUnitSubType_RemoteIO
        outputDescription.componentManufacturer = kAudioUnitManufacturer_Apple
        AUGraphAddNode(audioGraph, &outputDescription, &outputNode)
        
        AUGraphConnectNodeInput(audioGraph, mixerNode, 0, outputNode, 0)
        
        AUGraphOpen(audioGraph)
        
        AUGraphNodeInfo(audioGraph, mixerNode, nil, &mixerUnit)
        AUGraphNodeInfo(audioGraph, outputNode, nil, &outputUnit)
        
        AUGraphInitialize(audioGraph)
    }
}

extension AudioMixer {
    func start() {
        if let audioGraph = audioGraph {
            AUGraphStart(audioGraph)
        }
        
    }
    
    func stop() {
        if let audioGraph = audioGraph {
            AUGraphStop(audioGraph)
        }
        
    }
}

extension AudioMixer {
    func setInput(inputNumber: UInt32, format: inout AudioStreamBasicDescription, renderCallback: inout AURenderCallbackStruct) {
        // Set the render callback for the input
        AudioUnitSetProperty(mixerUnit!, kAudioUnitProperty_SetRenderCallback, kAudioUnitScope_Input, inputNumber, &renderCallback, UInt32(MemoryLayout<AURenderCallbackStruct>.size))
        
        // Set the input format
        AudioUnitSetProperty(mixerUnit!, kAudioUnitProperty_StreamFormat, kAudioUnitScope_Input, inputNumber, &format, UInt32(MemoryLayout<AudioStreamBasicDescription>.size))
    }
}

class RTCAudioMananger {
    var onAudioFrameCall: OnAudioFrameCall?
    var _audioMix: AudioMixer?
    var _elemetIndex: UInt32 = 0
    
    var elementAndUIdPair: [UInt: UInt32] = [UInt: UInt32]()
    
    //获取整个频道的远程声音
    public func captureChannelAudioFrame(onAudioFrameCall: OnAudioFrameCall?) {
        self.onAudioFrameCall = onAudioFrameCall
    }
    
    
//    public func mixPCMData(uid: UInt, data: UnsafeMutableRawPointer, dataBytes: Int) {
//        if _audioMix == nil {
//            _audioMix = AudioMixer()
//        }
//
//        guard let audioMix = _audioMix else{
//            return
//        }
//
//
//
//        audioMix.setInput(inputNumber: ++, format: &<#T##AudioStreamBasicDescription#>, renderCallback: &<#T##AURenderCallbackStruct#>)
//
//        _elemetNumber =
//    }
    
    
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
        
        let dst = buffer.mutableAudioBufferList.pointee.mBuffers
        memcpy(dst.mData, data, Int(dst.mDataByteSize))

//        var uint8Pointer: UnsafeMutablePointer<UInt8>?
//        buffer.int16ChannelData?.pointee.withMemoryRebound(to: UInt8.self, capacity: length) { ptr in
//            uint8Pointer = UnsafeMutablePointer<UInt8>(mutating: ptr)
//        }
//
//        guard let uint8Pointer = uint8Pointer else {
//            return
//        }
//
//        memcpy(uint8Pointer, data, length)
        onAudioFrameCall(buffer)
    }
}
