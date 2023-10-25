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
import AVFAudio
import AVKit

public class AudioChildConverter {
    var _baseConvert: AudioBaseConverter?
    
    required public init(sampleRate: Int, commonFormat: AVAudioCommonFormat, channel: Int) {
        _baseConvert = AudioBaseConverter(sampleRate: sampleRate, commonFormat: commonFormat, channel: channel,delegate: self)
    }
}

extension AudioChildConverter: CreateProcessNodeProtocol {
    internal func onProcessUnitCreate(addToAttach: (AVAudioNode) -> Void) {
        let eqNode = AVAudioUnitEQ(numberOfBands: 3)
        let pitchNode = AVAudioUnitTimePitch()
        let highPassFilterNode = AVAudioUnitEQ(numberOfBands: 1)
        
        
        eqNode.globalGain = 0
        eqNode.bands[0].filterType = .parametric
        eqNode.bands[0].frequency = 100
        eqNode.bands[0].bandwidth = 1
        eqNode.bands[0].gain = 1

        eqNode.bands[1].filterType = .parametric
        eqNode.bands[1].frequency = 900
        eqNode.bands[1].bandwidth = 1
        eqNode.bands[1].gain = -7

        eqNode.bands[2].filterType = .parametric
        eqNode.bands[2].frequency = 2500
        eqNode.bands[2].bandwidth = 1
        eqNode.bands[2].gain = -10



        let pitch = 8 * 100
        pitchNode.pitch = Float(pitch)

    
        highPassFilterNode.bands[0].filterType = .highPass
        highPassFilterNode.bands[0].frequency = 120
        
        addToAttach(eqNode)
        addToAttach(pitchNode)
        addToAttach(highPassFilterNode)
    }
}

extension AudioChildConverter : AudioProcessor {
    public func onPcmDataCallBack(onPcmDataCallBack: OnPcmDataCallBack?) {
        _baseConvert?._onPcmDataCallBack = onPcmDataCallBack
    }
    public func pushPCMData(data: AVAudioPCMBuffer) {
        _baseConvert?.pushPCMData(data: data)
    }
}



