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




public class AudioMaleConverter {
    var _baseConvert: AudioBaseConverter?
    
    required public init(sampleRate: Int, commonFormat: AVAudioCommonFormat, channel: Int) {
        _baseConvert = AudioBaseConverter(sampleRate: sampleRate, commonFormat: commonFormat, channel: channel, delegate: self)
    }
}

extension AudioMaleConverter: CreateProcessNodeProtocol {
    internal func onProcessUnitCreate(addToAttach: (AVAudioNode) -> Void) {
        
        let pitchEffectNode = AVAudioUnitTimePitch()
        let lowPassFilterNode = AVAudioUnitEQ(numberOfBands: 1)
        let eq = AVAudioUnitEQ(numberOfBands: 1)
        
        lowPassFilterNode.bands[0].filterType = .lowPass
        lowPassFilterNode.bands[0].frequency = 2000

        pitchEffectNode.pitch = -200

        eq.globalGain = 1.8
        
        addToAttach(lowPassFilterNode)
        addToAttach(pitchEffectNode)
        addToAttach(eq)
    }
}

extension AudioMaleConverter : AudioProcessor {
    public func onPcmDataCallBack(onPcmDataCallBack: OnPcmDataCallBack?) {
        _baseConvert?._onPcmDataCallBack = onPcmDataCallBack
    }
    public func pushPCMData(data: AVAudioPCMBuffer) {
        _baseConvert?.pushPCMData(data: data)
    }
}
