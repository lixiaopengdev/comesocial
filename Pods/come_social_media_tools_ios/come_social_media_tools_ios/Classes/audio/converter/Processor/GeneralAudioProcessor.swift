//
//  GeneralProcessor.swift
//  come_social_media_tools_ios
//
//  Created by 于冬冬 on 2023/3/20.
//

import Foundation
import AVKit

public final class GeneralAudioProcessor: AudioProcessor {
    let sampleRate: Int
    let commonFormat: AVAudioCommonFormat
    let channel: Int
    var converterType: ConverterType?
    
    var processor: AudioProcessor?
    {
        didSet {
            processor?.onPcmDataCallBack(onPcmDataCallBack: pcmDataCallBack)
        }
    }
    var pcmDataCallBack: OnPcmDataCallBack? {
        didSet {
            processor?.onPcmDataCallBack(onPcmDataCallBack: pcmDataCallBack)
        }
    }
    
    public init(sampleRate: Int, commonFormat: AVAudioCommonFormat, channel: Int) {
        self.sampleRate = sampleRate
        self.commonFormat = commonFormat
        self.channel = channel
    }
    
    public func changeConvert(_ type: ConverterType?) {
        if converterType == type {
            return
        }
        converterType = type
        guard let converterType = type else {
            processor = nil
            return
        }
        let convertorType = converterType.converterType()
        processor = convertorType.init(sampleRate: sampleRate, commonFormat: commonFormat, channel: channel)
    }

    
    public func onPcmDataCallBack(onPcmDataCallBack: OnPcmDataCallBack?) {
        pcmDataCallBack = onPcmDataCallBack
    }

    
    public func pushPCMData(data: AVAudioPCMBuffer) {
        if let processor = processor {
            processor.pushPCMData(data: data)
        } else {
            pcmDataCallBack?(data)
        }
    }
    
    
}
