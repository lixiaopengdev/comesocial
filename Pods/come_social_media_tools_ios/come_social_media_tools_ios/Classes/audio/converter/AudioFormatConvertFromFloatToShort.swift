//
//  AudioFormatConvert.swift
//  come_social_media_tools_ios
//
//  Created by fuhao on 2023/3/20.
//

import Foundation
import AVFoundation

//MARK: - 将32位Float音频采样转换成16位Int音频采样
public class AudioFormatConvertFromFloatToShort {
    var converter: AVAudioConverter? = nil
    var convertBuffer: AVAudioPCMBuffer? = nil
    let targetFormat = AVAudioFormat(commonFormat: AVAudioCommonFormat.pcmFormatInt16, sampleRate: 44100, channels: 1, interleaved: false)!
    
    public init(){}
    
    public func recordCallback(buffer: AVAudioPCMBuffer) -> AVAudioPCMBuffer? {
        if converter == nil {
            convertBuffer = AVAudioPCMBuffer(pcmFormat: targetFormat, frameCapacity: buffer.frameCapacity)
            convertBuffer?.frameLength = convertBuffer!.frameCapacity
            converter = AVAudioConverter(from: buffer.format, to: convertBuffer!.format)
            converter?.sampleRateConverterAlgorithm = AVSampleRateConverterAlgorithm_Normal

        }

        guard let convertBuffer = convertBuffer else { return nil }

        
//        print("Source buffer format: \(buffer.format)")
//        print("target buffer foamrt: \(targetFormat)")

        do {
            try converter!.convert(to: convertBuffer, from: buffer)
        } catch let error {
            print("Conversion error: \(error)")
            return nil
        }

        return convertBuffer
    }
}
