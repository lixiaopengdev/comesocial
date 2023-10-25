//
//  AudioSessionManager.swift
//  come_social_media_tools_ios
//
//  Created by fuhao on 2023/6/9.
//

import Foundation



//enum AudioSessionType {
//    case record
//    case play
//    case together
//
//    var audioSession: AVAudioSession {
//        switch self {
//        case .play:
//            let session = AVAudioSession.sharedInstance()
//            try? session.setCategory(.soloAmbient)
//            try? session.setMode(.default)
//            return session
//        case .record:
//            let session = AVAudioSession.sharedInstance()
//            try? session.setCategory(.playAndRecord, options: [.mixWithOthers])
//            try? session.setMode(.default)
//            return session
//        case .together:
//            let session = AVAudioSession.sharedInstance()
//            try? session.setCategory(.playAndRecord, options: [.allowBluetooth, .mixWithOthers, .defaultToSpeaker])
//            try? session.setMode(.videoChat)
//            try? session.overrideOutputAudioPort(.speaker)
//            return session
//        }
//    }
//}


//提供策略，管理音频Session
internal class AudioSessionManager : NSObject{
    internal static let shared = AudioSessionManager()

    var currentCategory: AVAudioSession.Category? = nil
    var currentMode: AVAudioSession.Mode? = nil
    var currentOptions: AVAudioSession.CategoryOptions? = nil
    
    
    private override init() {
        super.init()
        registerAVAudioSession()
    }
    
    func updateAudioSession() {
//        let captured = AudioCaptureSessionManager.shared.isCapture()
//        let rendered = AudioRenderSessionManager.shared.isRender()
//
//
//        if captured && rendered {
//            setAudioSession(type: .together)
//            return
//        }
//
//        guard captured == false else {
//            setAudioSession(type: .record)
//            return
//        }
//
//        guard captured == false else {
//            setAudioSession(type: .play)
//            return
//        }
//
        
        guard let currentCategory = currentCategory,
              let currentMode = currentMode,
              currentCategory == .playAndRecord,
              currentMode.rawValue == AVAudioSession.Mode.voiceChat.rawValue else {
            
            
            currentCategory = .playAndRecord
            currentMode = .voiceChat
            
            let session = AVAudioSession.sharedInstance()
            try? session.setCategory(.playAndRecord, options: [.mixWithOthers])
            try? session.setMode(.voiceChat)
            
            let currentRoute = session.currentRoute
            if (currentRoute.outputs.first(where: { return $0.portType == .headphones || $0.portType == .bluetoothA2DP || $0.portType == .bluetoothHFP}) != nil) == false {
                try? session.overrideOutputAudioPort(.speaker)
            }else{
                try? session.overrideOutputAudioPort(.none)
            }


            try? session.setActive(true, options: .notifyOthersOnDeactivation)

            return
        }
        

    }
    
    func restoreAudioSessionChange() {
        print("== == == notifyAudioSessionChange")
        AudioCaptureSessionManager.shared.restoreState()
        AudioRenderSessionManager.shared.restoreState()
    }
    
//    func setAudioSession(type: AudioSessionType) {
//        let targetAudioSession = type.audioSession
//        if currentCategory != nil {
//            print("== == == currentAudioSession ca:\(currentCategory) mode: \(currentMode) currentOptions:\(currentOptions)")
//        }
//
//        print("== == == targetAudioSession ca:\(targetAudioSession.category) mode: \(targetAudioSession.mode) currentOptions:\(targetAudioSession.categoryOptions)")
//
//        guard let currentCategory = currentCategory,
//              let currentMode = currentMode,
//              currentCategory == targetAudioSession.category,
//              currentMode.rawValue == targetAudioSession.mode.rawValue,
//              currentOptions?.rawValue == targetAudioSession.categoryOptions.rawValue else {
//
////            targetAudioSession.overrideOutputAudioPort(.speaker)
////            if type == .together {
////
////                try? targetAudioSession.setPreferredInput(AVAudioSessionPortDescription?)
////            }
//
//            try? targetAudioSession.setActive(true)
//            restoreAudioSessionChange()
//            return
//        }
//    }


}

private extension AudioSessionManager {
    private func registerAVAudioSession() {
        // 添加通知
        NotificationCenter.default.addObserver(self, selector: #selector(audioSessionRouteChanged(_:)), name: AVAudioSession.routeChangeNotification, object: nil)

        // 耳机插入和拔出
        NotificationCenter.default.addObserver(self, selector: #selector(audioSessionSilenceSecondaryAudioHint(_:)), name: AVAudioSession.silenceSecondaryAudioHintNotification, object: nil)

        // 中断开始和结束
        NotificationCenter.default.addObserver(self, selector: #selector(audioSessionInterruption(_:)), name: AVAudioSession.interruptionNotification, object: nil)

        // 来电中断开始和结束
        NotificationCenter.default.addObserver(self, selector: #selector(audioSessionMediaServicesWereLost(_:)), name: AVAudioSession.mediaServicesWereLostNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(audioSessionMediaServicesWereReset(_:)), name: AVAudioSession.mediaServicesWereResetNotification, object: nil)

        // 系统音量变化
//        NotificationCenter.default.addObserver(self, selector: #selector(audioSessionVolumeChanged(_:)), name: NSNotification.Name(rawValue: "AVSystemController_SystemVolumeDidChangeNotification"), object: nil)
    }
    
    
    
    @objc private func audioSessionMediaServicesWereLost(_ notification: Notification) {
        // 处理来电中断开始的逻辑
        print("处理来电中断开始的逻辑")
    }

    @objc private func audioSessionMediaServicesWereReset(_ notification: Notification) {
        // 处理来电中断结束的逻辑
        print("处理来电中断结束的逻辑")
    }
    
    @objc private func audioSessionInterruption(_ notification: Notification) {
        print("===== audioSessionInterruption")
        guard let userInfo = notification.userInfo,
            let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
            let type = AVAudioSession.InterruptionType(rawValue: typeValue) else { return }
            
        switch type {
            case .began:
                // 处理中断开始的逻辑
            print("处理中断开始的逻辑")
        
            break
            case .ended:
                guard let optionsValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt else { return }
                let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue)
                if options.contains(.shouldResume) {
                    // 处理中断结束并恢复的逻辑
                    print("处理中断结束并恢复的逻辑")
                    restoreAudioSessionChange()
                } else {
                    // 处理中断结束但不需要恢复的逻辑
                    print("处理中断结束但不需要恢复的逻辑")
                }
            break
        }
    }
    
    @objc private func audioSessionSilenceSecondaryAudioHint(_ notification: Notification) {
        print("===== audioSessionSilenceSecondaryAudioHint")
        guard let userInfo = notification.userInfo,
            let typeValue = userInfo[AVAudioSessionSilenceSecondaryAudioHintTypeKey] as? UInt,
              let type = AVAudioSession.SilenceSecondaryAudioHintType(rawValue: typeValue) else {
            return
        }
                
        switch type {
            case .begin:
                // 处理耳机插入或蓝牙设备连接的逻辑
            print("处理耳机插入或蓝牙设备连接的逻辑")
            break
            case .end:
                // 处理耳机拔出或蓝牙设备断开的逻辑
            print("处理耳机拔出或蓝牙设备断开的逻辑")
            break
        }
    }
    
    
    // 监听方法
    @objc private func audioSessionRouteChanged(_ notification: Notification) {
        print("===== audioSessionRouteChanged")
        guard let userInfo = notification.userInfo,
            let reasonValue = userInfo[AVAudioSessionRouteChangeReasonKey] as? UInt,
            let reason = AVAudioSession.RouteChangeReason(rawValue: reasonValue) else { return }
            
        switch reason {
        case .oldDeviceUnavailable:
            guard let audioSession = notification.object as? AVAudioSession else {
                break
            }
                // 处理 AVAudioSession 状态变化
            print("audio 路由改变 oldDeviceUnavailable")
            let currentRoute = audioSession.currentRoute
            if (currentRoute.outputs.first(where: { return $0.portType == .headphones || $0.portType == .bluetoothA2DP || $0.portType == .bluetoothHFP}) != nil) == false {
                try? audioSession.overrideOutputAudioPort(.speaker)
                try? audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            }else{
                try? audioSession.overrideOutputAudioPort(.none)
                try? audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            }
            
            break
        case .newDeviceAvailable:
            guard let audioSession = notification.object as? AVAudioSession else {
                break
            }
            print("audio 路由改变 newDeviceAvailable")
            let currentRoute = audioSession.currentRoute
            if (currentRoute.outputs.first(where: { return $0.portType == .headphones || $0.portType == .bluetoothA2DP || $0.portType == .bluetoothHFP}) != nil) == false {
                try? audioSession.overrideOutputAudioPort(.speaker)
                try? audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            }else{
                try? audioSession.overrideOutputAudioPort(.none)
                try? audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            }
            break
        case .categoryChange:
            print("audio 路由改变 categoryChange")
            guard let audioSession = notification.object as? AVAudioSession else {
                return
            }
            currentCategory = audioSession.category
            currentMode = audioSession.mode
            currentOptions = audioSession.categoryOptions
            print("== == == categoryChange ca:\(currentCategory) mode: \(currentMode) currentOptions:\(currentOptions)")
//            updateAudioSession()
            break
        case .unknown:
            print("audio 路由改变 unknown")
            break
        case .override:
            print("audio 路由改变 override")
            break
        case .wakeFromSleep:
            print("audio 路由改变 wakeFromSleep")
            break
        case .noSuitableRouteForCategory:
            print("audio 路由改变 noSuitableRouteForCategory")
            break
        case .routeConfigurationChange:
            print("audio 路由改变 routeConfigurationChange")
            break
        @unknown default:
            print("audio 路由改变 @unknown")
            break
        }
    }
    
    func printAudioSessionParameters(newAudioSession: AVAudioSession?) {
        var audioSession: AVAudioSession! = newAudioSession
        if newAudioSession == nil {
            audioSession = AVAudioSession.sharedInstance()
        }
        
        
        print("==========================================")
        do {
            
            
            // Print Audio Session Parameters
            print("Audio Session Parameters:")
            print("Category: \(audioSession.category)")
            print("Mode: \(audioSession.mode)")
            print("CategoryOptions: \(audioSession.categoryOptions.rawValue)")
            print("SampleRate: \(audioSession.sampleRate)")
            print("PreferredIOBufferDuration: \(audioSession.preferredIOBufferDuration)")
            print("InputGain: \(audioSession.inputGain)")
            print("OutputVolume: \(audioSession.outputVolume)")
            print("InputNumberOfChannels: \(audioSession.inputNumberOfChannels)")
            print("OutputNumberOfChannels: \(audioSession.outputNumberOfChannels)")
            print("InputDataSources: \(audioSession.inputDataSources)")
            print("OutputDataSources: \(audioSession.outputDataSources)")
            print("InputLatency: \(audioSession.inputLatency)")
            print("OutputLatency: \(audioSession.outputLatency)")
            print("InputAvailable: \(audioSession.isInputAvailable)")
//            print("OutputAvailable: \(audioSession.isOutputAvailable)")
            
            let currentRoute = audioSession.currentRoute
            print("Current Route:")
            for output in currentRoute.outputs {
                print("  PortType: \(output.portType)")
                print("  Channels: \(output.channels)")
                print("  UID: \(output.uid)")
//                print("  Manufacturer: \(output.manufacturer ?? "")")
            }
            
        } catch {
            print("Error setting up audio session: \(error.localizedDescription)")
        }
        
        print("==========================================")
    }
}
