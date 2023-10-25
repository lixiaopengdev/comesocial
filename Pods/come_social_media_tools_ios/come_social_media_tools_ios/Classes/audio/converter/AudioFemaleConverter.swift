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





public class AudioFemaleConverter {
    var _baseConvert: AudioBaseConverter?
    
    required public init(sampleRate: Int, commonFormat: AVAudioCommonFormat, channel: Int) {
        _baseConvert = AudioBaseConverter(sampleRate: sampleRate, commonFormat: commonFormat, channel: channel, delegate: self)
    }
}

extension AudioFemaleConverter: CreateProcessNodeProtocol {
    internal func onProcessUnitCreate(addToAttach: (AVAudioNode) -> Void) {
        
        let pitchEffectNode = AVAudioUnitTimePitch()
        let highPassFilterNode = AVAudioUnitEQ(numberOfBands: 1)
        
        pitchEffectNode.pitch = 4 * 100
        
        highPassFilterNode.bands[0].filterType = .highPass
        highPassFilterNode.bands[0].frequency = 8000
        
        addToAttach(pitchEffectNode)
        addToAttach(highPassFilterNode)
    }
}

extension AudioFemaleConverter : AudioProcessor {
    public func onPcmDataCallBack(onPcmDataCallBack: OnPcmDataCallBack?) {
        _baseConvert?._onPcmDataCallBack = onPcmDataCallBack
    }
    public func pushPCMData(data: AVAudioPCMBuffer) {
        _baseConvert?.pushPCMData(data: data)
    }
}


