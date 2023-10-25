//
//  AudioEQProcessor.swift
//  come_social_media_tools_ios
//
//  Created by fuhao on 2023/3/8.
//

import Foundation
import AudioToolbox
import CoreAudio
import AVFoundation


public class AudioOgreConverter {
    var _baseConvert: AudioBaseConverter?
    
    required public init(sampleRate: Int, commonFormat: AVAudioCommonFormat, channel: Int) {
        _baseConvert = AudioBaseConverter(sampleRate: sampleRate, commonFormat: commonFormat, channel: channel, delegate: self)
    }
}

extension AudioOgreConverter: CreateProcessNodeProtocol {
    internal func onProcessUnitCreate(addToAttach: (AVAudioNode) -> Void) {
        
        
        
        let pitchNode = AVAudioUnitTimePitch()
        pitchNode.pitch = -300


        let distortionNode = AVAudioUnitDistortion()
        distortionNode.preGain = -32

        let lowPassFilterNode = AVAudioUnitEQ(numberOfBands: 1)
        lowPassFilterNode.bands[0].filterType = .lowPass
        lowPassFilterNode.bands[0].frequency = 1600

        let amplifyNode = AVAudioUnitEQ()
        amplifyNode.globalGain = 0.56
        

        
        addToAttach(pitchNode)
        addToAttach(distortionNode)
        addToAttach(lowPassFilterNode)
        addToAttach(amplifyNode)
    }
}

extension AudioOgreConverter : AudioProcessor {
    public func onPcmDataCallBack(onPcmDataCallBack: OnPcmDataCallBack?) {
        _baseConvert?._onPcmDataCallBack = onPcmDataCallBack
    }
    public func pushPCMData(data: AVAudioPCMBuffer) {
        _baseConvert?.pushPCMData(data: data)
    }
}





