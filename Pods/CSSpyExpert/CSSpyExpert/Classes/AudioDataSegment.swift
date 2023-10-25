//
//  AudioDataSegment.swift
//  CSSpyExpert
//
//  Created by fuhao on 2023/4/21.
//

import Foundation
import come_social_media_tools_ios


public typealias OnAudioSegment = (_ audioBuffer: AVAudioPCMBuffer,_ timeStamp: Int64)->Void

class AudioDataSegment {
    private var _audioCaptureSession: AudioCaptureSession?
    private let _queue: DispatchQueue = DispatchQueue(label: "AudioDataSegment")
    
    private let _cacheSize: AVAudioFrameCount
    private let _bufferSize: AVAudioFrameCount
    
    private let _bufferFormat: AVAudioFormat
    private let _cacheFormat: AVAudioFormat
    private var _cacheAudioBuffer: AVAudioPCMBuffer
    
    private var _audioConverter: AVAudioConverter?
    
    var fillSampleNum = 0
    
    var _onAudioSegment: OnAudioSegment?
    
    var _currentUnixTimeStamp: Int64 = 0
        
    init() {
        _cacheSize = AVAudioFrameCount(10 * 44100) // 30 seconds at 44.1kHz
        _bufferSize = AVAudioFrameCount(10 * 16000) // 30 seconds at 16kHz
        _bufferFormat = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: 16000, channels: 1, interleaved: false)!
        _cacheFormat = AVAudioFormat(commonFormat: .pcmFormatInt16, sampleRate: 44100, channels: 1, interleaved: false)!
        _cacheAudioBuffer = AVAudioPCMBuffer(pcmFormat: _cacheFormat, frameCapacity: _cacheSize)!
        
        
        guard let audioConverter = AVAudioConverter(from: _cacheFormat, to: _bufferFormat) else { return }
        _audioConverter = audioConverter
        
        _currentUnixTimeStamp = Int64(Date().timeIntervalSince1970 * 1000)
    
    }
    

    private func resetAudioBuffer() {
        fillSampleNum = 0
        _currentUnixTimeStamp = Int64(Date().timeIntervalSince1970 * 1000)
    }
    
    
    func createTempFile() -> URL? {
        do {
            let fileManager = FileManager.default
            let tempDirURL = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let tempFileURL = tempDirURL.appendingPathComponent(UUID().uuidString)
            fileManager.createFile(atPath: tempFileURL.path, contents: nil, attributes: nil)
            return tempFileURL
        } catch {
            print("Error creating temp file: \(error)")
            return nil
        }
    }
    
    func writeBufferToFile(buffer: AVAudioPCMBuffer, fileURL: URL) {
        do {
            let file = try AVAudioFile(forWriting: fileURL, settings: buffer.format.settings)
            try file.write(from: buffer)
        } catch let error {
            print("Error writing buffer to file: \(error.localizedDescription)")
        }
    }
    
    func _handlePcmBufferFromMic(pcmBuffer: AVAudioPCMBuffer) {
//                print("Channel: \(pcmBuffer.format.channelCount)")
//                print("采样数: \(pcmBuffer.frameLength)")
//                print("采样位数: \(pcmBuffer.format.streamDescription.pointee.mBytesPerFrame * 8)")
//                print("采样率: \(pcmBuffer.format.sampleRate)Hz")
        //        guard let speechRecognizer = _speechRecognizer else {
        //            return
        //        }AVAudioBuffer
        //
        //        speechRecognizer.recognizePCMBuffer(pcmBuffer: pcmBuffer)
        
        guard let onAudioSegment = _onAudioSegment else {
            return
        }
        guard let audioConverter = _audioConverter else {
            return
        }
        guard fillSampleNum != _cacheSize else {
            print("丢弃。。。。。。")
            return
        }
        
        
        //拷贝
        let appendSampleNum = Int(pcmBuffer.frameLength)
        var addSampleNum = appendSampleNum
        var remainSampleNum = 0
        
        if (fillSampleNum + appendSampleNum) >= _cacheSize {
            addSampleNum = Int(_cacheSize) - fillSampleNum
            remainSampleNum = appendSampleNum - addSampleNum
        }
        
        memcpy(_cacheAudioBuffer.int16ChannelData![0] + fillSampleNum, pcmBuffer.int16ChannelData![0], addSampleNum * MemoryLayout<Int16>.size)
        fillSampleNum = fillSampleNum + addSampleNum
        
        if fillSampleNum == _cacheSize {
            _cacheAudioBuffer.frameLength = _cacheAudioBuffer.frameCapacity
            print("======  _cacheAudioBuffer.frameLength: \(_cacheAudioBuffer.frameLength)  _cacheAudioBuffer.frameCapacity: \(_cacheAudioBuffer.frameCapacity)")
            //转换
            let tempAudioBuffer = AVAudioPCMBuffer(pcmFormat: _bufferFormat, frameCapacity: _bufferSize)!
            let inputBlock: AVAudioConverterInputBlock = { inNumPackets, outStatus in
                outStatus.pointee = AVAudioConverterInputStatus.haveData
                return self._cacheAudioBuffer
            }
//            print("=== AudioDataSegment 创建 转换音频采样：\(Int(tempAudioBuffer.frameLength))")
            
            var error: NSError?
            let status = audioConverter.convert(to: tempAudioBuffer, error: &error, withInputFrom: inputBlock)
            guard status != .error && error == nil else { return }
            
//            print("=== AudioDataSegment 完成 转换音频采样：\(tempAudioBuffer)")
            
//            if let file = createTempFile() {
//                print("创建临时文件:\(file)")
//                writeBufferToFile(buffer: tempAudioBuffer, fileURL: file)
//            }
            onAudioSegment(tempAudioBuffer,_currentUnixTimeStamp)
            resetAudioBuffer()
        }
        
        if remainSampleNum > 0 {
            memcpy(_cacheAudioBuffer.int16ChannelData![0] + fillSampleNum, pcmBuffer.int16ChannelData![0] + addSampleNum, remainSampleNum * MemoryLayout<Int16>.size)
            fillSampleNum = fillSampleNum + remainSampleNum
        }
        
    }
    
    func handlePcmBufferFromMic(pcmBuffer: AVAudioPCMBuffer) {
        _queue.async { [weak self] in
            self?._handlePcmBufferFromMic(pcmBuffer: pcmBuffer)
        }
    }
}

extension AudioDataSegment {
    
    
    
    func startTask(onAudioSegment: OnAudioSegment?) {
        print("=== AudioDataSegment 启动")
        _onAudioSegment = onAudioSegment
        
        if _audioCaptureSession == nil {
            guard let audioCaptureSession = AudioCaptureSessionManager.shared.captureAudioFromMic() else {
                return
            }
            _audioCaptureSession = audioCaptureSession
            _audioCaptureSession?.OnAudioCaptureCallBack(callBack: { [weak self] pcmBuffer in
                self?.handlePcmBufferFromMic(pcmBuffer: pcmBuffer)
            })
        }
    }
    
    func stopTask() {
        _audioCaptureSession = nil
    }
}
