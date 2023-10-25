//
//  AudioBaseConverter.swift
//  come_social_media_tools_ios
//
//  Created by fuhao on 2023/3/27.
//

import Foundation
import AVKit


public typealias OnPcmDataCallBack = (_ data: AVAudioPCMBuffer)->Void

internal protocol CreateProcessNodeProtocol{
    func onProcessUnitCreate(addToAttach: (_ node: AVAudioNode)->Void)
}

internal class AudioBaseConverter {
    var _audioAVEngine: AVAudioEngine
    
    var _frameCount:AVAudioFrameCount = 4096
    var _onPcmDataCallBack: OnPcmDataCallBack?
    
    let _excuteQueue: DispatchQueue = DispatchQueue(label: "AudioUnitEQ")
    var _outputBuf: AVAudioPCMBuffer?
    var _inputNode: AVAudioPlayerNode
    var _attachNodes: [AVAudioNode] = []
    
    //mix输出的format
    var commonPCMFormat: AVAudioFormat
    //连接的fomat
    var _connectFormat: AVAudioFormat
    //输入的format
    var _inputFormat: AVAudioFormat
    
    var _delegate: CreateProcessNodeProtocol
    
    
    var convertedBuffer: AVAudioPCMBuffer?
    var converter: AVAudioConverter?
    
    required internal init(sampleRate: Int, commonFormat: AVAudioCommonFormat, channel: Int, delegate: CreateProcessNodeProtocol) {
        _delegate = delegate
        _audioAVEngine = AVAudioEngine()
        commonPCMFormat = _audioAVEngine.mainMixerNode.outputFormat(forBus: 0)
        _connectFormat = commonPCMFormat
        _inputFormat = commonPCMFormat
        _inputNode = AVAudioPlayerNode()
    
        setupAudioEngine(sampleRate: sampleRate, commonFormat: commonFormat, channel: channel)
    }
    
    deinit {
        _inputNode.stop()
        _audioAVEngine.stop()
        
        _audioAVEngine.detach(_inputNode)
        _attachNodes.forEach { unit in
            _audioAVEngine.detach(unit)
        }
    }
      
    private func setupAudioEngine(sampleRate: Int, commonFormat: AVAudioCommonFormat, channel: Int) {

        
        
        guard let format1 = AVAudioFormat(commonFormat: commonFormat, sampleRate: Double(sampleRate), channels: AVAudioChannelCount(channel), interleaved: false) else {
            return
        }
        _inputFormat = format1
        
        guard let format2 = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: Double(sampleRate), channels: AVAudioChannelCount(channel), interleaved: false) else {
            return
        }
        _connectFormat = format2
        
        
        print("mix的format: \(commonPCMFormat) 链接的format:\(String(describing: _connectFormat))  输入的format:\(String(describing: _inputFormat))")
        
        
        
        do {
            try _audioAVEngine.enableManualRenderingMode(.realtime, format: _inputFormat, maximumFrameCount: _frameCount)
        } catch {
            print("Error starting AVAudioEngine.")
        }

//        let inputBuf = AVAudioPCMBuffer(pcmFormat: _connectFormat, frameCapacity: _frameCount)!
        
        let outputBuf = AVAudioPCMBuffer(pcmFormat: _inputFormat, frameCapacity: _frameCount)!
//        print("outputBuf 格式: \(outputBuf.format.formatDescription) , \(outputBuf.frameCapacity), \(outputBuf.frameLength)")
//        _inputBuf = inputBuf
        _outputBuf = outputBuf
        
        
        _attachNodes.removeAll()
        _delegate.onProcessUnitCreate(addToAttach: { node in
            _attachNodes.append(node)
        })
        
        
        _audioAVEngine.attach(_inputNode)
        _attachNodes.forEach { audioUnit in
            _audioAVEngine.attach(audioUnit)
        }
        
        
        if _attachNodes.isEmpty {
            _audioAVEngine.connect(_inputNode, to: _audioAVEngine.mainMixerNode, format: _connectFormat)
        }else{
            var lastNode:AVAudioNode = _inputNode
            _attachNodes.forEach { audioUnit in
                _audioAVEngine.connect(lastNode, to: audioUnit, format: _connectFormat)
                lastNode = audioUnit
            }
            _audioAVEngine.connect(lastNode, to: _audioAVEngine.mainMixerNode, format: _connectFormat)
        }
        
        

        
        
//        _audioAVEngine.connect(_inputNode, to: eqNode, format: _connectFormat)
//        _audioAVEngine.connect(eqNode, to: pitchNode, format: _connectFormat)
//        _audioAVEngine.connect(pitchNode, to: highPassFilterNode, format: _connectFormat)
//        _audioAVEngine.connect(highPassFilterNode, to: _audioAVEngine.mainMixerNode, format: _connectFormat)
        
        
    
        do {
            try _audioAVEngine.start()
            _inputNode.play()
        } catch {
            print("Error starting AVAudioEngine.")
        }
    }
    
    private func conver(inputBuffer: AVAudioPCMBuffer) -> AVAudioPCMBuffer? {
        if _inputFormat.sampleRate != _connectFormat.sampleRate || _inputFormat.commonFormat != _connectFormat.commonFormat {
            
            if converter == nil {
                converter = AVAudioConverter(from: _inputFormat, to: _connectFormat)
            }
            
            if convertedBuffer == nil {
                convertedBuffer = AVAudioPCMBuffer(pcmFormat: _connectFormat, frameCapacity: _frameCount)
//                print("inputBuffer 格式: \(inputBuffer.format.formatDescription) , \(inputBuffer.frameCapacity), \(inputBuffer.frameLength)")
//                print("convertedBuffer 格式: \(convertedBuffer?.format.formatDescription) , \(convertedBuffer?.frameCapacity), \(convertedBuffer?.frameLength)")
            }
            
            
            
            guard let converter = converter,
                  let convertedBuffer = convertedBuffer else {
                return inputBuffer
            }
            
            do {
                convertedBuffer.frameLength = convertedBuffer.frameCapacity
                converter.convert(to: convertedBuffer, error: nil) { packetCount, status in
                    status.pointee = .haveData
                    return inputBuffer
                }

            } catch {
                return inputBuffer
            }
            
            return convertedBuffer
        }
        
        return inputBuffer
    }
    
    private func updatePCMQueue(inputBuffer: AVAudioPCMBuffer) {
        
        guard let inputBuffer = conver(inputBuffer: inputBuffer) else {
            return
        }
        
        
        guard let outputBuf = _outputBuf else {
            return
        }
        outputBuf.frameLength = _frameCount
        
        _inputNode.scheduleBuffer(inputBuffer, at: nil, options: [])
        var err: OSStatus = 0
        guard _audioAVEngine.manualRenderingBlock(_frameCount, outputBuf.mutableAudioBufferList, &err) == .success else {
            print("err: \(err)")
            return
        }
        
        
        //call back
        guard let onPcmDataCallBack = _onPcmDataCallBack else {
            return
        }
//        print("outputBuf 格式: \(outputBuf.format.formatDescription) , \(outputBuf.frameCapacity), \(outputBuf.frameLength)")
        
//        let bufferRawPointer = outputBuf.audioBufferList.pointee.mBuffers.mData
//        let opaquePtr = OpaquePointer(bufferRawPointer)
//        guard let baseAddress = UnsafeMutablePointer<UInt8>(opaquePtr) else {
//            return
//        }
//        let bufferSize = outputBuf.audioBufferList.pointee.mBuffers.mDataByteSize
        
        
        onPcmDataCallBack(outputBuf)
    }

}

extension AudioBaseConverter {
    internal func onPcmDataCallBack(onPcmDataCallBack: OnPcmDataCallBack?) {
        _onPcmDataCallBack = onPcmDataCallBack
    }
    internal func pushPCMData(data: AVAudioPCMBuffer) {
//        _cacheBuffer.writeBuffer(data, readBytes: Int32(frameCount))
//        guard _cacheBuffer.getAvaliableSize() >= _frameCount else {
//            return
//        }
        
        _excuteQueue.async { [weak self] in
            self?.updatePCMQueue(inputBuffer: data)
        }
    }
}
