//
//  SessionManager.swift
//  FlowYourLife
//
//  Created by fuhao on 2023/3/28.
//

import Foundation
import AVKit



public typealias OnAudioCaptureCallBack = (_ pcmBuffer: AVAudioPCMBuffer) -> Void

public class AudioCaptureSession {
    let id = UUID()
    var _captureCallBack: OnAudioCaptureCallBack?
    
    public init() {
        AudioCaptureSessionManager.shared.onSessionRegister(session: self)
    }
    
    deinit {
        AudioCaptureSessionManager.shared.onSessionRelease(session: self)
    }

    
    internal func pushPCMBuffer(pcmBuffer: AVAudioPCMBuffer) {
        guard let captureCallBack = _captureCallBack else {
            return
        }
        
        captureCallBack(pcmBuffer)
    }
}

public extension AudioCaptureSession {
    func OnAudioCaptureCallBack(callBack: OnAudioCaptureCallBack?) {
        _captureCallBack = callBack
    }
}




struct AudioCaptureSessionWeakRef {
    weak var ref: AudioCaptureSession?
}


class AudioCaptureDelegateForNative : NSObject, AudioCaptureNativeDelegate{
    public func audioController(_ controller: AudioCaptureNative!, didCaptureData pcmBuffer: AVAudioPCMBuffer!) {
        AudioCaptureSessionManager.shared.didCaptureData(pcmBuffer: pcmBuffer)
    }
}



public class AudioCaptureSessionManager {
    public static let shared = AudioCaptureSessionManager()
    private init() {}
    
    private var _audioCaptureSessions: [AudioCaptureSessionWeakRef] = []
    private var _singleAudioCapture: AudioCaptureNative?
    
    private let _delegate = AudioCaptureDelegateForNative()
    
    public func captureAudioFromMic() -> AudioCaptureSession? {
        return AudioCaptureSession()
    }
    
    
    //session 注册时
    internal func onSessionRegister(session: AudioCaptureSession) {
        _audioCaptureSessions.append(AudioCaptureSessionWeakRef(ref: session))
        startAudioCapture()
    }
    
    //session 释放时回调
    internal func onSessionRelease(session: AudioCaptureSession) {
        _audioCaptureSessions = _audioCaptureSessions.filter { ref in
            guard let ss = ref.ref else {
                return false
            }
            return ss.id != session.id
        }
        
        
        guard _audioCaptureSessions.isEmpty else {
            return
        }
        stopAudioCapture()
    }
    
    internal func isCapture() -> Bool{
        _audioCaptureSessions = _audioCaptureSessions.filter { ref in
            ref.ref != nil
        }
        
        return !_audioCaptureSessions.isEmpty
    }
    
    internal func restoreState() {
        _singleAudioCapture?.stopWork()
        if isCapture() {
            _singleAudioCapture?.startWork()
        }
    }

    
    
    private func startAudioCapture() {
        if _singleAudioCapture == nil {
            AudioSessionManager.shared.updateAudioSession()
            _singleAudioCapture = AudioCaptureNative()
            _singleAudioCapture?.delegate = _delegate
        }
        guard let singleAudioCapture = _singleAudioCapture else {
            return
        }
        singleAudioCapture.startWork()
    }
    
    private func stopAudioCapture() {
        _singleAudioCapture?.stopWork()
        _singleAudioCapture = nil
    }
    
    fileprivate func didCaptureData(pcmBuffer: AVAudioPCMBuffer) {
        _audioCaptureSessions.forEach { wrapper in
            guard let session = wrapper.ref else {
                return
            }

            session.pushPCMBuffer(pcmBuffer: pcmBuffer)
        }
    }
}


