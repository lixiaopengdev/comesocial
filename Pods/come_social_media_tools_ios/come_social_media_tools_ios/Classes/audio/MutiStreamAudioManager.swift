////
////  MutiStreamAudioPlayer.swift
////  come_social_media_tools_ios
////
////  Created by fuhao on 2023/3/20.
////
//
//import Foundation
//import AVFoundation
//
//public protocol AudioCaptureDelegate {
//    func didCaptureData(data: AVAudioPCMBuffer)
//}
//
//internal enum runningMode {
//    case record
//    case playAndRecord
//    case none
//}
//
//
////支持从麦克风采集数据，
////支持多路音频播放
//public class MutiStreamAudioManager {
//    
//    var _engineForRecord:AVAudioEngine?
//    var _engineForPlayerAndRecord:AVAudioEngine?
//    
//    var _runningMode: runningMode = .none
//    var _playerNodes = [Int:AVAudioPlayerNode]()
//    
//    
//    var _targetFormat: AVAudioFormat
//    var _sampleRate: Double = 44100
//    var _channel: AVAudioChannelCount = 1
//    var _audioRenderInputFormat: AVAudioFormat?
//    let _sourceAudioFormat:AVAudioFormat
//    
//    var _isRenderStarted: Bool = false
//    var _isCaptureStarted: Bool = false
//    
//    public var delegate: AudioCaptureDelegate?
//    
//    public init(sampleRate: Int, channel: Int) {
//        _sampleRate = Double(sampleRate)
//        _channel = AVAudioChannelCount(channel)
//        _targetFormat = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: _sampleRate, channels: _channel, interleaved: false)!
//        _sourceAudioFormat = AVAudioFormat(commonFormat: .pcmFormatInt16, sampleRate: _sampleRate, channels: _channel, interleaved: false)!
//    }
//    
//    func getPlayerNodeByTrackId(trackId: Int) -> AVAudioPlayerNode? {
//        if let playerNode = _playerNodes[trackId] {
//            return playerNode
//        }
//        
//        guard _isRenderStarted else{
//            return nil
//        }
//        
//       
//        guard let _engineForPlayerAndRecord = _engineForPlayerAndRecord,
//            _engineForPlayerAndRecord.isRunning else {
//            return nil
//        }
//        
//        let playerNode = AVAudioPlayerNode()
//        _playerNodes[trackId] = playerNode
//        _engineForPlayerAndRecord.attach(playerNode)
//        _audioRenderInputFormat = _engineForPlayerAndRecord.mainMixerNode.inputFormat(forBus: 0)
//        print("connect player node format:\(String(describing: _sourceAudioFormat))")
//        _engineForPlayerAndRecord.connect(playerNode, to: _engineForPlayerAndRecord.mainMixerNode, format: _sourceAudioFormat)
//
//        playerNode.play()
//        
//        return playerNode
//    }
//    
//    func convert(buffer: AVAudioPCMBuffer, using converter: AVAudioConverter) -> AVAudioPCMBuffer? {
//        if converter.outputFormat.sampleRate == buffer.format.sampleRate && converter.outputFormat.commonFormat == buffer.format.commonFormat {
//            return buffer
//        }
//        
//        
//        let outputFrameCount = AVAudioFrameCount(Double(buffer.frameCapacity) / buffer.format.sampleRate * converter.outputFormat.sampleRate )
//        let outputBuffer = AVAudioPCMBuffer(pcmFormat: converter.outputFormat, frameCapacity: outputFrameCount)!
//        var error: NSError?
//        let inputBlock: AVAudioConverterInputBlock = { (inNumPackets, outStatus) -> AVAudioBuffer? in
//            outStatus.pointee = AVAudioConverterInputStatus.haveData
//            return buffer
//        }
//        converter.convert(to: outputBuffer, error: &error, withInputFrom: inputBlock)
//        if let err = error {
//            print("Error converting audio: \(err)")
//            return nil
//        }
//        return outputBuffer
//    }
//}
//
//public extension MutiStreamAudioManager {
//    func isRenderWorked() -> Bool {
//        return _isRenderStarted
//    }
//    
//    func isCaptureWorked() -> Bool {
//        return _isCaptureStarted
//    }
//    
//    internal func determineStatus() -> runningMode {
//        if _isRenderStarted && _isCaptureStarted {
//            return .playAndRecord
//        }else if (_isCaptureStarted) {
//            return .record
//        }
//        
//        return .none
//    }
//    
//    internal func updateAudioSession() {
//        let audioSession = AVAudioSession.sharedInstance()
//        print(" 1=== current categora: \(audioSession.category)")
//        do {
//            switch _runningMode {
//            case .record:
//                try audioSession.setCategory(.playAndRecord, options: .interruptSpokenAudioAndMixWithOthers)
//                try audioSession.setMode(.videoChat)
//                try audioSession.setActive(true)
//                try audioSession.setPreferredInput(audioSession.availableInputs?.first)
//                break
//            case .playAndRecord:
//                try audioSession.setCategory(.playAndRecord, options: .interruptSpokenAudioAndMixWithOthers)
//                try audioSession.setMode(.videoChat)
//                try audioSession.setActive(true)
//                try audioSession.setPreferredInput(audioSession.availableInputs?.first)
//                break
//            default:
//                try audioSession.setActive(false)
//                break
//            }
//            
//        } catch {
//            print("Error setting up audio session: \(error.localizedDescription)")
//        }
//        
//        print(" 2=== current categora: \(audioSession.category)")
//    }
//    
//    internal func stopAudioEngine() {
//        switch _runningMode {
//        case .record:
//            guard let engineForPlayerAndRecord = _engineForPlayerAndRecord else {
//                return
//            }
//            engineForPlayerAndRecord.stop()
//            engineForPlayerAndRecord.reset()
//            
//            _engineForPlayerAndRecord = nil
//            break
//        case .playAndRecord:
//            guard let engineForRecord = _engineForRecord else {
//                return
//            }
//            
//            engineForRecord.stop()
//            engineForRecord.reset()
//            
//            _engineForRecord = nil
//            break
//        default:
//            if let engineForRecord = _engineForRecord {
//                engineForRecord.stop()
//                engineForRecord.reset()
//                _engineForRecord = nil
//            }
//            
//            if let engineForPlayerAndRecord = _engineForPlayerAndRecord {
//                engineForPlayerAndRecord.stop()
//                engineForPlayerAndRecord.reset()
//                _engineForPlayerAndRecord = nil
//            }
//            
//            
//            break
//        }
//    }
//    
//    func initRecordAndPlayAudioEngine() {
//        if _engineForPlayerAndRecord == nil {
//            _engineForPlayerAndRecord = AVAudioEngine()
//        }
//        guard let _engineForPlayerAndRecord = _engineForPlayerAndRecord else {
//            return
//        }
//        let inputNode = _engineForPlayerAndRecord.inputNode
//        let audioCaptureFormat = inputNode.outputFormat(forBus: 0)
//        print("_targetFormat: \(_targetFormat)")
//        print("audioCaptureFormat: \(audioCaptureFormat)")
//        
//        
//        inputNode.installTap(onBus: 0, bufferSize: AVAudioFrameCount(audioCaptureFormat.sampleRate * 0.1), format: audioCaptureFormat) { [weak self] (buffer, time) in
//            guard let capture = self else {
//                return
//            }
//            guard let data = buffer.floatChannelData?[0] else {
//                return
//            }
//            
//            
//            let pcmBuffer = AVAudioPCMBuffer(pcmFormat: capture._targetFormat, frameCapacity: buffer.frameCapacity)!
//            pcmBuffer.frameLength = buffer.frameCapacity
//
//            // 获取可变的音频缓冲区列表
//            let audioBufferList = pcmBuffer.mutableAudioBufferList
//            
//            var byteOffset = 0
//            // 将 UInt8 数据写入音频缓冲区列表
//            for bufferIndex in 0..<Int(audioBufferList.pointee.mNumberBuffers) {
//                let audioBuffer = audioBufferList.advanced(by: bufferIndex).pointee.mBuffers
//                let byteCount = Int(audioBuffer.mDataByteSize)
//                let destination = audioBuffer.mData?.assumingMemoryBound(to: UInt8.self)
//                let source = data.advanced(by: byteOffset)
//                memcpy(destination, source, byteCount)
//                byteOffset += byteCount
//            }
//
//            let audioFormatConverter = AVAudioConverter(from: audioCaptureFormat, to: capture._targetFormat)!
//            guard let convertedData = capture.convert(buffer: pcmBuffer, using: audioFormatConverter),
//                  let floatData = convertedData.floatChannelData?[0] else {
//                return
//            }
////
//            
//            capture.delegate?.didCaptureData(data: pcmBuffer)
//        }
//        
//        print("想要渲染的 format : \(_sourceAudioFormat)")
//        
//        
//        _engineForPlayerAndRecord.connect(_engineForPlayerAndRecord.mainMixerNode, to: _engineForPlayerAndRecord.outputNode, format: nil)
//        
//        print("mixer i format : \(_engineForPlayerAndRecord.mainMixerNode.inputFormat(forBus: 0))")
//        print("mixer o format : \(_engineForPlayerAndRecord.mainMixerNode.outputFormat(forBus: 0))")
//        
//        
//        do {
//            _engineForPlayerAndRecord.prepare()
//            try _engineForPlayerAndRecord.start()
//        } catch let error {
//            _engineForPlayerAndRecord.stop()
//            _engineForPlayerAndRecord.reset()
//            print("Error fetching contents of URL: \(error.localizedDescription)")
//            _isRenderStarted = false
//        }
//        
//        
//
//        
//    }
//    
//    func initRecordAudioEngine() {
//        if _engineForRecord == nil {
//            _engineForRecord = AVAudioEngine()
//        }
//        guard let _engineForRecord = _engineForRecord else {
//            return
//        }
//        
//        let inputNode = _engineForRecord.inputNode
//        let audioCaptureFormat = inputNode.outputFormat(forBus: 0)
//        print("_targetFormat: \(_targetFormat)")
//        print("audioCaptureFormat: \(audioCaptureFormat)")
//        inputNode.removeTap(onBus: 0)
//        
//        inputNode.installTap(onBus: 0, bufferSize: AVAudioFrameCount(audioCaptureFormat.sampleRate * 0.1), format: audioCaptureFormat) { [weak self] (buffer, time) in
//            guard let capture = self else {
//                return
//            }
//            guard let data = buffer.floatChannelData?[0] else {
//                return
//            }
//            
//            
//            let pcmBuffer = AVAudioPCMBuffer(pcmFormat: capture._targetFormat, frameCapacity: buffer.frameCapacity)!
//            pcmBuffer.frameLength = buffer.frameCapacity
//
//            // 获取可变的音频缓冲区列表
//            let audioBufferList = pcmBuffer.mutableAudioBufferList
//            
//            var byteOffset = 0
//            // 将 UInt8 数据写入音频缓冲区列表
//            for bufferIndex in 0..<Int(audioBufferList.pointee.mNumberBuffers) {
//                let audioBuffer = audioBufferList.advanced(by: bufferIndex).pointee.mBuffers
//                let byteCount = Int(audioBuffer.mDataByteSize)
//                let destination = audioBuffer.mData?.assumingMemoryBound(to: UInt8.self)
//                let source = data.advanced(by: byteOffset)
//                memcpy(destination, source, byteCount)
//                byteOffset += byteCount
//            }
//
//            let audioFormatConverter = AVAudioConverter(from: audioCaptureFormat, to: capture._targetFormat)!
//            guard let convertedData = capture.convert(buffer: pcmBuffer, using: audioFormatConverter),
//                  let floatData = convertedData.floatChannelData?[0] else {
//                return
//            }
////
//            
//            capture.delegate?.didCaptureData(data: pcmBuffer)
//        }
//
//        do {
//            _engineForRecord.prepare()
//            try _engineForRecord.start()
//        } catch let error {
//            _engineForRecord.stop()
//            _engineForRecord.reset()
//            print("Error fetching contents of URL: \(error.localizedDescription)")
//            _isCaptureStarted = false
//        }
//    }
//    
//    internal func resumeAudioEngine(){
//        switch _runningMode {
//        case.record:
//            initRecordAudioEngine()
//            break
//        case .playAndRecord:
//            initRecordAndPlayAudioEngine()
//            break
//        default:
//            break
//        }
//    }
//    
//    func setupSession() {
//        //判断状态
//        let currentMode = determineStatus()
//        print(" == currentMode \(currentMode)")
//        guard _runningMode != currentMode else {
//            return
//        }
//        _runningMode = currentMode
//        //停止引擎
//        stopAudioEngine()
//        //更新会话
//        updateAudioSession()
//        //恢复引擎
//        resumeAudioEngine()
//    }
//    
//    
//    
//    
//    func startRenderWork() {
//        guard !_isRenderStarted else {
//            return
//        }
//        _isRenderStarted = true
//        
//        setupSession()
////        let engine = createAudioEngine()
////        if _outputNode == nil {
////            _outputNode = engine.outputNode
////        }
////        let outputNode = _outputNode!
////
////        startAudioEngine()
////        if _mainMixerNode == nil {
////            _mainMixerNode = engine.mainMixerNode
////        }
////        let mainMixerNode = _mainMixerNode!
////
////        print("mixer i format : \(mainMixerNode.inputFormat(forBus: 0))")
////        print("mixer o format : \(mainMixerNode.outputFormat(forBus: 0))")
////
////
////        engine.connect(mainMixerNode, to: outputNode, format: mainMixerNode.outputFormat(forBus: 0))
////
////        print("output i format : \(outputNode.outputFormat(forBus: 0))")
////        print("output o format : \(outputNode.outputFormat(forBus: 0))")
////
////        _playerNodes.forEach { key, node in
////            node.play()
////        }
//        
//
//    }
//    
//    
//    func stopRenderWork() {
//        guard _isRenderStarted else {
//            return
//        }
//        _isRenderStarted = false
//        setupSession()
////        let engine = createAudioEngine()
////
////
////        _playerNodes.forEach { key,node in
////            node.stop()
////        }
////        let mainMixerNode = _mainMixerNode!
////        engine.disconnectNodeOutput(mainMixerNode)
//        
////        stopAudioEngine()
//    }
//    
//
////    func createAudioEngine() -> AVAudioEngine{
////        if let engine = _engine {
////            return engine
////        }
////        _engine = AVAudioEngine()
////        return _engine!
////    }
//    
////    func startAudioEngine() {
////        if let engine = _engine,
////           _isEnginePlaying == false {
////            do {
////                engine.prepare()
////                try engine.start()
////                _isEnginePlaying = true
////            } catch let error {
////                print("Error fetching contents of URL: \(error.localizedDescription)")
////                _isCaptureStarted = false
////            }
////        }
////    }
//    
////    func stopAudioEngine() {
////        guard !_isCaptureStarted && !_isRenderStarted else {
////            return
////        }
////        let engine = createAudioEngine()
////        engine.stop()
////        _isEnginePlaying = false
////    }
//    
//    func startCaptureWork() {
//        print("=====  startCaptureWork")
//        guard !_isCaptureStarted  else {
//            return
//        }
//        _isCaptureStarted = true
//        
//        setupSession()
////        let engine = createAudioEngine()
////        if _inputNode == nil {
////            _inputNode = engine.inputNode
////        }
////        let inputNode = _inputNode!
////
////        if _outputNode == nil {
////            _outputNode = engine.outputNode
////        }
////        startAudioEngine()
////        if _mainMixerNode == nil {
////            _mainMixerNode = engine.mainMixerNode
////        }
////
////        let audioCaptureFormat = inputNode.outputFormat(forBus: 0)
////        print("_targetFormat: \(_targetFormat)")
////        print("audioCaptureFormat: \(audioCaptureFormat)")
////
////
////        inputNode.installTap(onBus: 0, bufferSize: AVAudioFrameCount(_targetFormat.sampleRate * 0.1), format: audioCaptureFormat) { [weak self] (buffer, time) in
////            guard let capture = self else {
////                return
////            }
////            guard let data = buffer.floatChannelData?[0] else {
////                return
////            }
////
////
////            let pcmBuffer = AVAudioPCMBuffer(pcmFormat: capture._targetFormat, frameCapacity: buffer.frameCapacity)!
////            pcmBuffer.frameLength = buffer.frameCapacity
////
////            // 获取可变的音频缓冲区列表
////            let audioBufferList = pcmBuffer.mutableAudioBufferList
////
////            var byteOffset = 0
////            // 将 UInt8 数据写入音频缓冲区列表
////            for bufferIndex in 0..<Int(audioBufferList.pointee.mNumberBuffers) {
////                let audioBuffer = audioBufferList.advanced(by: bufferIndex).pointee.mBuffers
////                let byteCount = Int(audioBuffer.mDataByteSize)
////                let destination = audioBuffer.mData?.assumingMemoryBound(to: UInt8.self)
////                let source = data.advanced(by: byteOffset)
////                memcpy(destination, source, byteCount)
////                byteOffset += byteCount
////            }
////
////            let audioFormatConverter = AVAudioConverter(from: audioCaptureFormat, to: capture._targetFormat)!
////            guard let convertedData = capture.convert(buffer: pcmBuffer, using: audioFormatConverter),
////                  let floatData = convertedData.floatChannelData?[0] else {
////                return
////            }
//////
////
////            capture.delegate?.didCaptureData(data: pcmBuffer)
////
////        }
//        
//    }
//    
//    
//    
//    func stopCaptureWork() {
//        print("=====  stopCaptureWork")
//        guard _isCaptureStarted else {
//            return
//        }
//        _isCaptureStarted = false
//        setupSession()
////        let engine = createAudioEngine()
////
////        let inputNode = _inputNode!
////        inputNode.removeTap(onBus: 0)
////
////        stopAudioEngine()
//    }
//    
//    
//    
//    func renderPCMData(trackId: Int, pcmData: AVAudioPCMBuffer) {
//        guard let playerNode = getPlayerNodeByTrackId(trackId: trackId) else {
//            return
//        }
//        playerNode.scheduleBuffer(pcmData)
//    }
//
//    
//    
//    
//    //trackId 代表不同的音轨，
//    func renderPCMData(trackId: Int, pcmData: UnsafeMutablePointer<UInt8>!, bytesLength: Int) {
//        guard let desAudioFormat = _audioRenderInputFormat else {
//            return
//        }
//
//        let frameCapacity = AVAudioFrameCount(bytesLength >> 1)
//        // 创建一个 AVAudioPCMBuffer
//        guard let pcmBuffer = AVAudioPCMBuffer(pcmFormat: _sourceAudioFormat, frameCapacity: frameCapacity) else {
//            return
//        }
//        pcmBuffer.frameLength = frameCapacity
//
//        guard let playerNode = getPlayerNodeByTrackId(trackId: trackId) else {
//            return
//        }
//
//        // 获取可变的音频缓冲区列表
//        let audioBufferList = pcmBuffer.mutableAudioBufferList
//
//        var byteOffset = 0
//        // 将 UInt8 数据写入音频缓冲区列表
//        for bufferIndex in 0..<Int(audioBufferList.pointee.mNumberBuffers) {
//            let audioBuffer = audioBufferList.advanced(by: bufferIndex).pointee.mBuffers
//            let byteCount = Int(audioBuffer.mDataByteSize)
//            let destination = audioBuffer.mData?.assumingMemoryBound(to: UInt8.self)
//            let source = pcmData.advanced(by: byteOffset)
//            memcpy(destination, source, byteCount)
//            byteOffset += byteCount
//        }
//
//        playerNode.scheduleBuffer(pcmBuffer)
//    }
//}
