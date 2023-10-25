//
//  AudioRenderSessionManager.swift
//  come_social_media_tools_ios
//
//  Created by fuhao on 2023/6/9.
//

import Foundation


struct AudioRenderSessionWeakRef {
    weak var ref: AudioRenderSession?
}


public class AudioRenderSession {
    let id = UUID()
    public init() {
        AudioRenderSessionManager.shared.onSessionRegister(session: self)
    }
    
    deinit {
        AudioRenderSessionManager.shared.onSessionRelease(session: self)
    }
    
    public func renderAudioBuffer(pcmBuffer: AVAudioPCMBuffer) {
        AudioRenderSessionManager.shared.renderAudioBuffer(pcmBuffer: pcmBuffer)
    }
}


internal class AudioRenderSessionManager {
    static let shared = AudioRenderSessionManager()
    private init() {}
    
    
    internal var _audioRenderSessions: [AudioRenderSessionWeakRef] = []
    internal var _singleAudioRender: AudioRenderNative?
    internal var _delegate = AudioCaptureDelegateForNative()
    
    
}

internal extension AudioRenderSessionManager {
    //session 注册时
    func onSessionRegister(session: AudioRenderSession) {
        _audioRenderSessions.append(AudioRenderSessionWeakRef(ref: session))
        startAudioRender()
    }
    
    //session 释放时回调
    func onSessionRelease(session: AudioRenderSession) {
        _audioRenderSessions = _audioRenderSessions.filter { ref in
            guard let ss = ref.ref else {
                return false
            }
            return ss.id != session.id
        }
        
        guard _audioRenderSessions.isEmpty else {
            return
        }
        
        stopAudioRender()
    }
    
    func isRender() -> Bool{
        _audioRenderSessions = _audioRenderSessions.filter { ref in
            ref.ref != nil
        }
        
        return !_audioRenderSessions.isEmpty
    }
    
    func restoreState() {
        
        _singleAudioRender?.stopWork()
        if isRender() {
            _singleAudioRender?.startWork()
        }
    }
    
    
    
    private func startAudioRender() {
        if _singleAudioRender == nil {
            AudioSessionManager.shared.updateAudioSession()
            _singleAudioRender = AudioRenderNative()
        }
        guard let singleAudioRender = _singleAudioRender else {
            return
        }
        singleAudioRender.startWork()
    }
    
    private func stopAudioRender() {
        _singleAudioRender?.stopWork()
        _singleAudioRender = nil
    }
    
    fileprivate func renderAudioBuffer(pcmBuffer: AVAudioPCMBuffer) {
        guard let singleAudioRender = _singleAudioRender else {
            return
        }
        
        singleAudioRender.pushPCMData(pcmBuffer)
    }
}


