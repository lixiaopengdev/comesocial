//
//  SpyExpert.swift
//  FlowYourLife
//
//  Created by fuhao on 2023/3/28.
//

import Foundation
import WhisperDiarization
import AVFAudio
import Combine
import CoreLocation

public enum PushInfo {
case location
case microphone
}



//负责从设备中监视数据的专家
public class SpyExpert {
    public static let shared = SpyExpert()
    
    var pushInfos: [PushInfo] = [.location, .microphone]
    @Published public private(set) var pushData: Bool = false

    
    let lifeFlowGenerateIntervals:Double = 66
    var _stateUpdateWorkItem: DispatchWorkItem?
    
    
    var _audioSegment:AudioDataSegment? = nil
    let _speechRecognition = CSSpeechRecognition()
    
    var ownerStartRecordTimeStamp:Int64 = 0
    var ownerEndRecordTimeStamp:Int64 = 0
    
    
    let timer: Timer
    
    
    private init() {
        timer = Timer.scheduledTimer(withTimeInterval: 66, repeats: true) {_ in
            SpyExpert.shared.handleLifeFlowDataPush()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(screenLocked), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(screenUnlocked), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    public func checkRecordingPermission() -> Int {
        let recordingPermissionStatus = AVAudioSession.sharedInstance().recordPermission
        
        switch recordingPermissionStatus {
        case .granted:
            // 已授予录音权限
            return 1
        case .denied:
            // 用户已拒绝录音权限
            return -1
        case .undetermined:
            // 录音权限尚未确定，需要请求权限
            return 0
        default:
            return 0
        }
    }
    
    public func checkLocationPermission() -> Int {
        let locationManager = CLLocationManager()
        
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .authorizedAlways, .authorizedWhenInUse:
                // 已授予定位权限
                return 1
            case .denied, .restricted:
                // 用户已拒绝或限制了定位权限
                return -1
            case .notDetermined:
                // 定位权限尚未确定，需要请求权限
//                locationManager.requestWhenInUseAuthorization()
                return 0
            @unknown default:
                return 0
            }
        } else {
            // 定位服务未启用
            return -1
        }
    }
    
    // 1. allow
    // 0. not true
    // -1. not allow
//    public func checkPermissions() -> Int {
//        let audioPermission = checkRecordingPermission()
//        guard audioPermission > 0 else {
//            return audioPermission
//        }
//        let locationPremission = checkLocationPermission()
//        guard locationPremission > 0 else {
//            return locationPremission
//        }
//
//        return 1
//    }
    
    
    
    fileprivate func startMic() {
        if checkRecordingPermission() == 1 {
            guard _audioSegment == nil,
                  hasPushInfo(info: .microphone),
                  pushData else {
                return
            }
            _audioSegment = AudioDataSegment()
            _audioSegment!.startTask {[weak self] audioBuffer,timeStamp in
                self?._speechRecognition.pushAudioBuffer(buffer: audioBuffer, timeStamp: timeStamp)
            }
        }else{
            _audioSegment = nil
        }
    }
    
    fileprivate func startLocation() {
        guard hasPushInfo(info: .location),
              pushData,
              checkLocationPermission() == 1 else {
            return
        }
        
        CSLocationManager.shared.requestCurrentLocation(nil)
    }
}


private extension SpyExpert {
    //执行生活流更新
    func handleLifeFlowDataPush() {
        var places: [PlaceMark] = []
        var speechs: [Transcript] = []
        let speechRecognitions:[TranscriptItem] = _speechRecognition.pullRecognition()
        startLocation()
        if hasPushInfo(info: .location) {
            let place = CSLocationManager.shared.getCurrentLocation()
            places.append(place)
        }
        
        if hasPushInfo(info: .microphone) {
            speechs = speechRecognitions.map { Transcript(label: $0.label, speech: $0.speech, startTimeStamp: $0.startTimeStamp, endTimeStamp: $0.endTimeStamp, features: []) }
            updateOwnerSpeechFeature(speechs: speechs)
        }
        
        guard pushData else {
            print("生活流停止发送")
            return
        }
        
        guard !pushInfos.isEmpty else {
            print("生活流没有内容")
            return
        }
        
        let pushInfo = UserPushInfoModel(speechs: speechs, locactions: places)
        CSNetService.pushLifeFlow(data: pushInfo) {[weak self] result in
            guard let result = result,
                  result == true else {
                //错误情况
                print("生活流发送失败")
                return
            }

            print("生活流发送成功")
        }
    }
    
    func updateOwnerSpeechFeature(speechs: [Transcript]) {
        if ownerStartRecordTimeStamp > 0 && ownerEndRecordTimeStamp > 0 {
            //TODO: 更新机主特征
            ownerStartRecordTimeStamp = 0
            ownerEndRecordTimeStamp = 0
        }
        
    }
    
}


//MARK: - API
public extension SpyExpert {
    
    
    func recordOwnerSpeech() {
        ownerStartRecordTimeStamp = Int64(Date().timeIntervalSince1970 * 1000)
        print("ownerStartRecordTimeStamp: \(ownerStartRecordTimeStamp)")
    }
    
    func finishRecordOwnerSpeech() {
        ownerEndRecordTimeStamp = Int64(Date().timeIntervalSince1970 * 1000)
        print("ownerStartRecordTimeStamp: \(ownerEndRecordTimeStamp)")
    }
    
    func startTask() {
        if checkRecordingPermission() > 0 || checkLocationPermission() > 0 {
            pushData = true
        }
        
        startMic()
        startLocation()
    }
    
    func stopTask() {
        pushData = false
        _audioSegment = nil
    }
    
    func isTaskRunning() -> Bool {
        return pushData
    }

    
    
    
    
    
    //开启推送数据
    func openPushInfo(info: PushInfo) {
        guard pushInfos.contains(where: {$0 == info}) == false else {
            return
        }
        pushInfos.append(info)
        
        switch info {
        case .microphone:
            startMic()
            break
            
        case .location:
            break
        }
    }
    
    //关闭推送数据
    func closePushInfo(info: PushInfo) {
        pushInfos.removeAll(where: {$0 == info})
        switch info {
        case .microphone:
            _audioSegment = nil
            break
            
        case .location:
            break
        }
    }
    
    func hasPushInfo(info: PushInfo) -> Bool {
        return pushInfos.contains(where: {$0 == info})
    }
    
    // 监听屏幕锁定事件
    @objc func screenLocked() {
        print("屏幕被锁定")
        if hasPushInfo(info: .location),
           checkLocationPermission() == 1 {
            CSLocationManager.shared.stopUpdateLocation()
            print("停止定位")
        }
        
        
    }

    // 监听屏幕解锁事件
    @objc func screenUnlocked() {
        print("屏幕已解锁")
        if hasPushInfo(info: .location),
           checkLocationPermission() == 1 {
            CSLocationManager.shared.requestCurrentLocation(nil)
            print("开始定位")
        }
        
    }
}


