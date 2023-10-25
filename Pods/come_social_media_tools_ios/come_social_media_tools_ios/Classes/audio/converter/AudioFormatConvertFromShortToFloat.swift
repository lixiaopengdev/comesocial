//
//  AudioFormatConvert.swift
//  come_social_media_tools_ios
//
//  Created by fuhao on 2023/3/20.
//

import Foundation
import AVFoundation

//MARK: - 将16位Int音频采样转换成32位Float音频采样
public class AudioFormatConvertFromShortToFloat {
    var converter: AVAudioConverter? = nil
    var convertBuffer: AVAudioPCMBuffer? = nil
    let targetFormat = AVAudioFormat(commonFormat: AVAudioCommonFormat.pcmFormatFloat32, sampleRate: 44100, channels: 2, interleaved: false)!
    
    public init(){}
    
    public func recordCallback(buffer: AVAudioPCMBuffer) -> AVAudioPCMBuffer? {
        if converter == nil {
            convertBuffer = AVAudioPCMBuffer(pcmFormat: targetFormat, frameCapacity: buffer.frameCapacity)
            convertBuffer?.frameLength = convertBuffer!.frameCapacity
            converter = AVAudioConverter(from: buffer.format, to: convertBuffer!.format)
            converter?.sampleRateConverterAlgorithm = AVSampleRateConverterAlgorithm_Normal
//            converter?.sampleRateConverterQuality = .high
        }

        guard let convertBuffer = convertBuffer else { return nil }

//        print("Converter: \(self.converter!)")
//        print("Converter buffer: \(self.convertBuffer!)")
//        print("Converter buffer format: \(self.convertBuffer!.format)")
//        print("Source buffer: \(buffer)")
//        print("Source buffer format: \(buffer.format)")

        do {
            try converter!.convert(to: convertBuffer, from: buffer)
        } catch let error {
            print("Conversion error: \(error)")
//            observer?.onError(EngineRecordTaskError.ConversionError(error: error))
            return nil
        }

        return convertBuffer
    }
    
    
    public func recordCallback(data: UnsafeMutablePointer<UInt8>, bufferSize: Int) -> AVAudioPCMBuffer? {
        let frameCapacity = AVAudioFrameCount(bufferSize >> 1)
        let sourceFormat = AVAudioFormat(commonFormat: .pcmFormatInt16, sampleRate: 44100, channels: 1, interleaved: false)!
        
        
        if converter == nil {
            convertBuffer = AVAudioPCMBuffer(pcmFormat: targetFormat, frameCapacity: frameCapacity)
            convertBuffer?.frameLength = convertBuffer!.frameCapacity
            converter = AVAudioConverter(from: sourceFormat, to: convertBuffer!.format)
            converter?.sampleRateConverterAlgorithm = AVSampleRateConverterAlgorithm_Normal
        }

        guard let convertBuffer = convertBuffer else { return nil }
        
        
        let pcmBuffer = AVAudioPCMBuffer(pcmFormat: sourceFormat, frameCapacity: frameCapacity)!
        pcmBuffer.frameLength = frameCapacity

        // 获取可变的音频缓冲区列表
        let audioBufferList = pcmBuffer.mutableAudioBufferList

        var byteOffset = 0
        // 将 UInt8 数据写入音频缓冲区列表
        for bufferIndex in 0..<Int(audioBufferList.pointee.mNumberBuffers) {
            let audioBuffer = audioBufferList.advanced(by: bufferIndex).pointee.mBuffers
            let byteCount = Int(audioBuffer.mDataByteSize)
            let destination = audioBuffer.mData?.assumingMemoryBound(to: UInt8.self)
            let source = data.advanced(by: byteOffset)
            memcpy(destination, source, byteCount)
            byteOffset += byteCount
        }
        do {
            try converter!.convert(to: convertBuffer, from: pcmBuffer)
        } catch let error {
            print("Conversion error: \(error)")
//            observer?.onError(EngineRecordTaskError.ConversionError(error: error))
            return nil
        }

        return convertBuffer
    }
}
