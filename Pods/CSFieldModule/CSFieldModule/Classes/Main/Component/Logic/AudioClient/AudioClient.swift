//
//  AudioClient.swift
//  Alamofire
//
//  Created by 于冬冬 on 2023/3/20.
//

import Foundation
import CSNetwork
import come_social_media_tools_ios
import ComeSocialRTCService
import Combine
import CSLogger
import CSFileKit
import CSUtilities

protocol AudioClientObserver: AnyObject {
    func audioClientUpdateBuffer(_ pcmBuffer: AVAudioPCMBuffer)
}

class AudioClient: NSObject, FieldComponent {

    var assembly: FieldAssembly
    
    var observers:[WeakWrapper<AudioClientObserver>] = []
    var audioCaptureSession: AudioCaptureSession?
    
    var isOpen: Bool {
        return audioCaptureSession != nil
    }
    
    required init(assembly: FieldAssembly) {
        self.assembly = assembly
        super.init()
    }
    
    
    func addObserver(_ ob: AudioClientObserver) {
        
        observers.append(WeakWrapper(ob))
        clearNilObserver()
        cheackStatus()
    }
    
    func removeObserver(_ ob: AudioClientObserver) {
        observers.removeAll { wrapper in
            wrapper.value === ob
        }
        clearNilObserver()
        cheackStatus()
    }
    
    func clearNilObserver() {
        observers.removeAll { wrapper in
            wrapper.value == nil
        }
    }
    
    func cheackStatus() {
        if observers.isEmpty {
            if isOpen {
                stopAudio()
            }
        } else {
            if !isOpen {
                startAudio()
            }
        }
    }
    
    func updateBuffer(_ pcmBuffer: AVAudioPCMBuffer) {
        for observer in observers {
            var clearEmpty = false
            if let value = observer.value {
                value.audioClientUpdateBuffer(pcmBuffer)
            } else {
                clearEmpty = true
            }
            if clearEmpty {
                clearNilObserver()
            }
        }
    }
    

    func startAudio() {
        if isOpen {
            return
        }

        audioCaptureSession = AudioCaptureSessionManager.shared.captureAudioFromMic()
        audioCaptureSession?.OnAudioCaptureCallBack(callBack: { [weak self] pcmBuffer in
            self?.updateBuffer(pcmBuffer)
        })
    }
    
    func stopAudio() {
        audioCaptureSession = nil
    }
    
    func changeEffect(name: String) {
        HUD.showError("audio is closed")
       return
    }
    
}

