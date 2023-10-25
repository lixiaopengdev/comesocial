//
//  PremissionManager.swift
//  FlowYourLife
//
//  Created by fuhao on 2023/3/28.
//

import Foundation
import AVFoundation
import AVRouting
import CoreLocation
import Speech
import CoreBluetooth
import CoreMotion
import Contacts
import MediaPlayer
import AddressBook
import EventKit
import Photos
import AVKit




public enum NeedPremission{
    case Microphone
//    case Camera
    case Location
//    case SpeechRecognizer
//    case Peripheral
//    case Motion
//    case Contacts
//    case Calendars
//    case Reminders
//    case Photos
//    case AppleMusic
}

public typealias onPermissionAuthorization = (Bool) -> Void


class LocalPremissionCallBack : NSObject, CLLocationManagerDelegate {
    let _onPermissionAuthorization:onPermissionAuthorization
    
    init(_onPermissionAuthorization: @escaping onPermissionAuthorization) {
        self._onPermissionAuthorization = _onPermissionAuthorization
        super.init()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            _onPermissionAuthorization(true)
        case .authorizedAlways:
            _onPermissionAuthorization(true)
        case .denied, .restricted:
            _onPermissionAuthorization(false)
        default:
            break
        }
    }
}


public class PremissionManager {
    public static let shared = PremissionManager()
    private init() {}
    
    
    var _locationMgr = CLLocationManager()
    var locationPremissionDelegate: LocalPremissionCallBack?
    
    var _needPremissions:[NeedPremission] = []
    
    var _onPermissionAuthorization: onPermissionAuthorization?
    
    public func requestPremissions(needPremissions: [NeedPremission], onPermissionAuthorization: onPermissionAuthorization?) {
        guard !needPremissions.isEmpty else {
            onPermissionAuthorization?(true)
            return
        }
        _needPremissions = needPremissions
        _onPermissionAuthorization = onPermissionAuthorization
        loopRequestPremissions()
    }
    
    
    func loopRequestPremissions() {
        DispatchQueue.main.async { [weak self] in
            self?._loopRequestPremissions()
        }
    }
    
    
    func _loopRequestPremissions() {

        guard let premission = _needPremissions.last else {
            guard let onPermissionAuthorization = _onPermissionAuthorization else {
                return
            }
            
            onPermissionAuthorization(true)
            return
        }
        
        
        switch premission {
        case .Microphone:
            requestPremissionForMicrophone()
            break
//        case .Camera:
//            requestPremissionForCamera()
//            break
        
        case .Location:
            requestPremissionForLocation()
            break
        
//        case .SpeechRecognizer:
//            requsetPremissionForSpeechRecognizer()
//            break
//
//        case .Peripheral:
//            requestPremissionForPeripheral()
//            break
//
//        case .Motion:
//            requestPremissionForMotion()
//            break
//
//        case .Contacts:
//            requestPremissionForContacts()
//            break
//
//        case .Calendars:
//            requestPremissionForCalendars()
//            break
//
//        case .Reminders:
//            requestPremissionForReminders()
//            break
//
//        case .Photos:
//            requestPremissionForPhotos()
//            break
//
//        case .AppleMusic:
//            requestPremissionForAppleMusic()
//            break
//
        }
        

    }
    
    
    //权限不满足
    func openSetting() {
        guard let onPermissionAuthorization = _onPermissionAuthorization else {
            return
        }
        
        onPermissionAuthorization(false)
    }
    
    
    func requestPremissionForMicrophone() {
        AVAudioSession.sharedInstance().requestRecordPermission { [weak self] _ in
            let status = AVAudioSession.sharedInstance().recordPermission
            if case status = AVAudioSession.RecordPermission.granted {
                self?._needPremissions.removeLast()
                self?.loopRequestPremissions()
            }else {
                self?.openSetting()
            }
        }
    }
    
    func requestPremissionForCamera() {
        AVCaptureDevice.requestAccess(for: .video) { [weak self] _ in
            let status = AVCaptureDevice.authorizationStatus(for: .video)
            if case status = AVAuthorizationStatus.authorized {
                self?._needPremissions.removeLast()
                self?.loopRequestPremissions()
            }else {
                self?.openSetting()
            }
        }
    }
    
    func requestPremissionForLocation() {
        
        let status  = CLLocationManager.authorizationStatus()
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            self._needPremissions.removeLast()
            self.loopRequestPremissions()
            return
        }
        
        if status == .notDetermined {
            if locationPremissionDelegate == nil {
                locationPremissionDelegate = LocalPremissionCallBack(_onPermissionAuthorization: { [weak self] result in
                    if result {
                        self?._needPremissions.removeLast()
                        self?.loopRequestPremissions()
                    }else{
                        self?.openSetting()
                    }
                    
                })
            }
            _locationMgr.delegate = locationPremissionDelegate
            _locationMgr.requestWhenInUseAuthorization()
            return
        }
        
        self.openSetting()
    }
//    
//    func requsetPremissionForSpeechRecognizer() {
//        SFSpeechRecognizer.requestAuthorization { [weak self] _ in
//            let status = SFSpeechRecognizer.authorizationStatus()
//            if status == .authorized {
//                self?._needPremissions.removeLast()
//                self?.loopRequestPremissions()
//            } else {
//                self?.openSetting()
//            }
//        }
//    }
//
//    func requestPremissionForPeripheral() {
//        let peripheralManagerDispatchQueue = DispatchQueue(label: "CBPeripheralManager")
//        let peripheral = CBPeripheralManager(delegate: nil, queue: peripheralManagerDispatchQueue, options: [CBPeripheralManagerOptionShowPowerAlertKey: true])
//
//        peripheral.startAdvertising(nil)
//        peripheral.stopAdvertising()
//
//        let status = CBPeripheralManager.authorizationStatus()
//
//        switch peripheral.state {
//        case .poweredOff:
//           break
//
//        case .poweredOn:
//           break
//
//        case .resetting:
//           break
//
//        case .unauthorized:
//           break
//
//        case .unsupported:
//           break
//
//        case .unknown:
//           break
//        }
//    }
    
//    func requestPremissionForMotion() {
//        let motionManager = CMMotionActivityManager()
//        let queue = OperationQueue()
//        queue.name = "CMMotionActivityManager"
//        queue.qualityOfService = .background
//        let semaphore = DispatchSemaphore(value: 0)
//        motionManager.queryActivityStarting(from: Date(), to: Date(), to: queue) { (motionActivities, error) in
//            if let nsError = (error as NSError?) {
//                let cmError = CMError(rawValue: UInt32(nsError.code))
//
//                switch cmError {
//                case CMErrorNULL:
//                    break
//                case CMErrorDeviceRequiresMovement:
//                    break
//                case CMErrorTrueNorthNotAvailable:
//                    break
//                case CMErrorUnknown:
//                    break
//                case CMErrorMotionActivityNotAvailable:
//                    break
//                case CMErrorMotionActivityNotAuthorized:
//                    break
//                case CMErrorMotionActivityNotEntitled:
//                    break
//                case CMErrorInvalidParameter:
//                    break
//                case CMErrorInvalidAction:
//                    break
//                case CMErrorNotEntitled:
//                    break
//                case CMErrorNotAvailable:
//                    break
//                case CMErrorNotAuthorized:
//                    break
//
//                default:
//                    break
//
//                }
//            }
//            motionManager.stopActivityUpdates()
//            semaphore.signal()
//        }
//        let _ = semaphore.wait(timeout: DispatchTime.distantFuture)
//    }
//
//    func requestPremissionForContacts() {
//        CNContactStore().requestAccess(for: .contacts) { (_, error) in
//            let status = CNContactStore.authorizationStatus(for: .contacts)
//            if case status = CNAuthorizationStatus.authorized {
//
//            } else {
//
//            }
//        }
//    }
//
//    func requestPremissionForCalendars() {
//        EKEventStore().requestAccess(to: .event) { (_, error) in
//            let status = EKEventStore.authorizationStatus(for: .event)
//        }
//    }
//
//    func requestPremissionForReminders() {
//        EKEventStore().requestAccess(to: .reminder) { (_, error) in
//            let status = EKEventStore.authorizationStatus(for: .reminder)
//        }
//    }
//
//    func requestPremissionForPhotos() {
//        PHPhotoLibrary.requestAuthorization { _ in
//            let status = PHPhotoLibrary.authorizationStatus()
//            if case status = PHAuthorizationStatus.authorized {
//
//            } else {
//
//            }
//        }
//
//    }
//
//    func requestPremissionForAppleMusic() {
//        MPMediaLibrary.requestAuthorization { _ in
//            let status = MPMediaLibrary.authorizationStatus()
//            print(status)
//            if case status = MPMediaLibraryAuthorizationStatus.authorized {
//
//            } else {
//
//            }
//        }
//    }
}
