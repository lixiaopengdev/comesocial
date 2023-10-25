//
//  ARKitManager.swift
//  ComeSocialDemo
//
//  Created by fuhao on 2022/9/19.
//

import Foundation
//import ARKit

public struct CSCameraCaptureConfig {
    let frame: Bool
    let arTrack: Bool
    let cameraTrakc: Bool
    public init(frame: Bool, arTrack: Bool = false, cameraTrakc: Bool = false) {
        self.frame = frame
        self.arTrack = arTrack
        self.cameraTrakc = cameraTrakc
    }
}


public struct CSCaptureSessionConfig {
    var frontCamera: CSCameraCaptureConfig?
    var rareCamera: CSCameraCaptureConfig?

    public init(frontCamera: CSCameraCaptureConfig?, rareCamera: CSCameraCaptureConfig?) {
        self.frontCamera = frontCamera
        self.rareCamera = rareCamera
    }
}



enum CaptureType {
    case None
    case ARKIT_FACIAL
    case ARKIT_WORLD
    case ARKIT_WORLD_WITH_FACIAL_DATA
    case FRONT_CAMERA
    case REAR_CAMERA
    case FRONT_REAR_CAMERA
}



//MARK: - 捕获会话
public class CSCaptureSession {
    weak var _service: ARAndCameraCaptureService?
    let _config: CSCaptureSessionConfig

//    var _onFrameUpdateCallBack: DidFrameUpdate?
//    var _onAnchorUpdateCallBack: DidAnchorUpdate?
//    var _onAddAnchorCallBack: DidAddAnchor?
//    var _onRemoveAnchorCallBack: DidRemoveAnchor?
//    var _onCaptureFacialDataCallBack: OnCaptureFacialData? = nil


    var _onFrontFrameUpdateCallBack: DidFrontFrameUpdate?
    var _onRareFrameUpdateCallBack: DidRareFrameUpdate?



    init(service: ARAndCameraCaptureService? = nil, config: CSCaptureSessionConfig) {
        _service = service
        _config = config
    }

    deinit {
        print("CSCaptureSession deint")
        ARAndCameraCaptureService.sharedInstance.resetCaptureSession()
    }
}

//MARK: - API
public extension CSCaptureSession {
//    typealias DidFrameUpdate = (_ frame: ARFrame) -> Void
//    typealias DidAnchorUpdate = (_ anchors: [ARAnchor]) -> Void
//    typealias DidAddAnchor = (_ anchors: [ARAnchor]) -> Void
//    typealias DidRemoveAnchor = (_ anchors: [ARAnchor]) -> Void
//
//
//    typealias OnCaptureFacialData = ([ARFaceAnchor]?) -> Void


    typealias DidFrontFrameUpdate = (_ frame: CVPixelBuffer, _ rotation: Int) -> Void
    typealias DidRareFrameUpdate = (_ frame: CVPixelBuffer, _ rotation: Int) -> Void


//    func onFrameDidUpdate(didFrameUpdate: DidFrameUpdate?) {
//        self._onFrameUpdateCallBack = didFrameUpdate
//    }

    func onCaptureFrontCamera(_ didFrontFrameUpdate: DidFrontFrameUpdate?) {
        self._onFrontFrameUpdateCallBack = didFrontFrameUpdate
    }

    func onCaptureRareCamera(_ didRareFrameUpdate: DidRareFrameUpdate?) {
        self._onRareFrameUpdateCallBack = didRareFrameUpdate
    }

//    func onAnchorUpdate(didAnchorUpdate: DidAnchorUpdate?) {
//        self._onAnchorUpdateCallBack = didAnchorUpdate
//    }
//
//    func onAnchorAdded(didAddAnchor: DidAddAnchor?) {
//        self._onAddAnchorCallBack = didAddAnchor
//    }
//
//    func onAnchorRemoved(didRemoveAnchor: DidRemoveAnchor?) {
//        self._onRemoveAnchorCallBack = didRemoveAnchor
//    }


//    //捕获ARKIT Facial 数据
//    func onCaptureFacialData(captureCallBack: OnCaptureFacialData?) {
//        //提前校验
//        if let camera = _config.frontCamera,
//           camera.arTrack {
//            _onCaptureFacialDataCallBack = captureCallBack
//        }
//    }
}






//MARK: - AR服务
public class ARAndCameraCaptureService : NSObject{
    //单例
    public static let sharedInstance = ARAndCameraCaptureService()

//    let _arSession: ARSession
    var _cameraCapture: Any?

    static let k_FrontFrameMask: Int = 1 << 1
    static let k_RareFrameMask: Int = 1 << 2
    static let k_FrontArFaice: Int = 1 << 3
    static let k_RareArWorld: Int = 1 << 4
    static let k_ArEnv: Int = 1 << 5

    var _currentCapture: CaptureType = .None


    struct CSCaptureSessionWrapper {
        weak var _session: CSCaptureSession?
        init(session: CSCaptureSession) {
            _session = session
        }
    }

    var _captureSessionQueue: [CSCaptureSessionWrapper] =  [CSCaptureSessionWrapper]()
    var _observeCaptureSessionQueue: [CSCaptureSessionWrapper] =  [CSCaptureSessionWrapper]()
    var _currentSessionConfig: CSCaptureSessionConfig?

    public override init() {
//        _arSession = ARSession()
        super.init()
//        _arSession.delegateQueue = DispatchQueue(label: "ARAndCameraCaptureService")
//        _arSession.delegate = self
    }

//    public func getARSession() -> ARSession {
//        return _arSession
//    }


}

extension ARAndCameraCaptureService {

    //停止Capture
    func stopCapture() {
//        _arSession.pause()
        if let mutilCameraCapture:MutiCameraCapture = _cameraCapture as? MutiCameraCapture {
            mutilCameraCapture.stopCapturing()
        } else if let cameraCapture:CameraCapture = _cameraCapture as? CameraCapture {
            cameraCapture.stopCapture()
        }
    }



    func setupCapture(captureType: CaptureType){
        switch captureType {
        case .ARKIT_FACIAL :

//            let configura = ARFaceTrackingConfiguration()
//            _arSession.run(configura, options: .resetSceneReconstruction)
            break

        case .ARKIT_WORLD :

//            let configura = ARWorldTrackingConfiguration()
//            configura.worldAlignment = .gravity
//            _arSession.run(configura, options: .resetSceneReconstruction)
            break
        case .ARKIT_WORLD_WITH_FACIAL_DATA :

//            let configura = ARWorldTrackingConfiguration()
//            configura.userFaceTrackingEnabled = true
//            configura.worldAlignment = .gravity
//            _arSession.run(configura, options: .resetSceneReconstruction)
            break

        case .FRONT_REAR_CAMERA :
            if let cameraCapture:CameraCapture = _cameraCapture as? CameraCapture {
                _cameraCapture = nil
            }

            if _cameraCapture == nil {
                _cameraCapture = MutiCameraCapture(delegate: self)
            }
            guard let mutiCameraCapture = _cameraCapture as? MutiCameraCapture else {
                return
            }
            mutiCameraCapture.startCapturing()

            break
        case .REAR_CAMERA :
            if let mutiCameraCapture:MutiCameraCapture = _cameraCapture as? MutiCameraCapture {
                _cameraCapture = nil

            }

            if _cameraCapture == nil {
                _cameraCapture = CameraCapture(delegate: self)
            }
            guard let singleCameraCapture = _cameraCapture as? CameraCapture else {
                return
            }
            singleCameraCapture.startCapture(ofCamera: .back)


            break
        case .FRONT_CAMERA :
            if let mutiCameraCapture:MutiCameraCapture = _cameraCapture as? MutiCameraCapture {
                _cameraCapture = nil
            }

            if _cameraCapture == nil {
                _cameraCapture = CameraCapture(delegate: self)
            }
            guard let singleCameraCapture = _cameraCapture as? CameraCapture else {
                return
            }
            singleCameraCapture.startCapture(ofCamera: .front)


            break
        default:
            break
        }
    }

    func matchCaptureType(stateCode: Int) -> CaptureType {
        var maskCode = 0

        //AR数据优先
        maskCode = ARAndCameraCaptureService.k_RareArWorld | ARAndCameraCaptureService.k_FrontArFaice | ARAndCameraCaptureService.k_ArEnv
        if stateCode & maskCode > 0 {
            if stateCode & maskCode == maskCode {
                return .ARKIT_WORLD_WITH_FACIAL_DATA
            }

            maskCode = ARAndCameraCaptureService.k_FrontArFaice
            if stateCode & maskCode == maskCode {
                return .ARKIT_FACIAL
            }

            maskCode = ARAndCameraCaptureService.k_RareArWorld
            if stateCode & maskCode == maskCode {
                return .ARKIT_WORLD
            }

            maskCode = ARAndCameraCaptureService.k_ArEnv
            if stateCode & maskCode == maskCode {
                return .ARKIT_FACIAL
            }
        }else{
            maskCode = ARAndCameraCaptureService.k_FrontFrameMask | ARAndCameraCaptureService.k_RareFrameMask
            if stateCode & maskCode == maskCode {
                return .FRONT_REAR_CAMERA
            }

            maskCode = ARAndCameraCaptureService.k_FrontFrameMask
            if stateCode & maskCode == maskCode {
                return .FRONT_CAMERA
            }

            maskCode = ARAndCameraCaptureService.k_RareFrameMask
            if stateCode & maskCode == maskCode {
                return .REAR_CAMERA
            }
        }
        return .None
    }

    //根据当前Session 更新Capture状态
    func updateCaptureState() {
        _captureSessionQueue = _captureSessionQueue.filter { wrapper in
            return wrapper._session != nil
        }
        _observeCaptureSessionQueue = _observeCaptureSessionQueue.filter({ wrapper in
            return wrapper._session != nil
        })



        //对所有session 计算出所有的需求
        var stateCode:Int = 0
        _captureSessionQueue.forEach { wrapper in
            guard let session = wrapper._session else {
                return
            }

            if let frontCamera = session._config.frontCamera {
                if frontCamera.frame {
                    stateCode = stateCode | ARAndCameraCaptureService.k_FrontFrameMask
                }
                if frontCamera.arTrack {
                    stateCode = stateCode | ARAndCameraCaptureService.k_FrontArFaice
                }

                if frontCamera.cameraTrakc {
                    stateCode |= ARAndCameraCaptureService.k_ArEnv
                }

            }

            if let rareCamera = session._config.rareCamera {
                if rareCamera.frame {
                    stateCode = stateCode | ARAndCameraCaptureService.k_RareFrameMask
                }
                if rareCamera.arTrack {
                    stateCode = stateCode | ARAndCameraCaptureService.k_RareArWorld
                }
                if rareCamera.cameraTrakc {
                    stateCode |= ARAndCameraCaptureService.k_ArEnv
                }
            }
        }

        guard stateCode != 0 else {
            stopCapture()
            return
        }

//        guard stateCode != _currentState else {
//            return
//        }
//        _currentState = stateCode

        let captureType = matchCaptureType(stateCode: stateCode)
        guard captureType != _currentCapture else {
            return
        }
        stopCapture()
        setupCapture(captureType: captureType)
    }
}


//MARK: - API
public extension ARAndCameraCaptureService {
    func openCaptureSession(config: CSCaptureSessionConfig) -> CSCaptureSession {
        let session = CSCaptureSession(service: self, config: config)
        _captureSessionQueue.append(CSCaptureSessionWrapper(session: session))
        updateCaptureState()
        return session
    }


    func openObserveCaptureSession() -> CSCaptureSession {
        let session = CSCaptureSession(service: self, config: CSCaptureSessionConfig(frontCamera: CSCameraCaptureConfig(frame: true, arTrack: true), rareCamera: CSCameraCaptureConfig(frame: true, arTrack: true)))
        _observeCaptureSessionQueue.append(CSCaptureSessionWrapper(session: session))
        updateCaptureState()
        return session
    }

    func resetCaptureSession() {
        updateCaptureState()
    }
}




////MARK: - ARKit delegate
//extension ARAndCameraCaptureService : ARSessionDelegate {
//    public func session(_ session: ARSession, didUpdate frame: ARFrame) {
//
//        for sessionWrapper in _captureSessionQueue {
//            guard let session = sessionWrapper._session,
//                  let onFrameUpdateCallBack = session._onFrameUpdateCallBack else {
//                continue
//            }
//
//            onFrameUpdateCallBack(frame)
//        }
//
//        for sessionWrapper in _observeCaptureSessionQueue {
//            guard let session = sessionWrapper._session,
//                  let onFrameUpdateCallBack = session._onFrameUpdateCallBack else {
//                continue
//            }
//
//            onFrameUpdateCallBack(frame)
//        }
//    }
//
//    public func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
//
////            let faceAnchors = anchors.compactMap { anchor -> ARFaceAnchor? in
////                anchor as? ARFaceAnchor
////            }
//
//            for sessionWrapper in _captureSessionQueue {
//                guard let captureSession = sessionWrapper._session else {
//                    continue
//                }
//
//                guard let onFaceAnchorAddedCallBack = captureSession._onAddAnchorCallBack else {
//                    continue
//                }
//
//                onFaceAnchorAddedCallBack(anchors)
//            }
//
//            for sessionWrapper in _observeCaptureSessionQueue {
//                guard let captureSession = sessionWrapper._session else {
//                    continue
//                }
//
//                guard let onFaceAnchorAddedCallBack = captureSession._onAddAnchorCallBack else {
//                    continue
//                }
//
//                onFaceAnchorAddedCallBack(anchors)
//            }
//
//    }
//
//    public func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
//
////        let faceAnchors = anchors.compactMap { anchor -> ARFaceAnchor? in
////            anchor as? ARFaceAnchor
////        }
//
//        for sessionWrapper in _captureSessionQueue {
//            guard let captureSession = sessionWrapper._session else {
//                continue
//            }
//
//            guard let onFaceAnchorUpdateCallBack = captureSession._onAnchorUpdateCallBack else {
//                continue
//            }
//
//            onFaceAnchorUpdateCallBack(anchors)
//        }
//
//        for sessionWrapper in _observeCaptureSessionQueue {
//            guard let captureSession = sessionWrapper._session else {
//                continue
//            }
//
//            guard let onFaceAnchorUpdateCallBack = captureSession._onAnchorUpdateCallBack else {
//                continue
//            }
//
//            onFaceAnchorUpdateCallBack(anchors)
//        }
//
//
//    }
//
//    public func session(_ session: ARSession, didRemove anchors: [ARAnchor]) {
//        for sessionWrapper in _captureSessionQueue {
//            guard let captureSession = sessionWrapper._session else {
//                continue
//            }
//
//            guard let onAnchorRemoteCallBack = captureSession._onRemoveAnchorCallBack else {
//                continue
//            }
//
//            onAnchorRemoteCallBack(anchors)
//        }
//
//        for sessionWrapper in _observeCaptureSessionQueue {
//            guard let captureSession = sessionWrapper._session else {
//                continue
//            }
//
//            guard let onAnchorRemoteCallBack = captureSession._onRemoveAnchorCallBack else {
//                continue
//            }
//
//            onAnchorRemoteCallBack(anchors)
//        }
//    }
//}


//MARK: - Camera delegate
extension ARAndCameraCaptureService : CameraCapturePushDelegate {
    public func cameraFrameCapture(pixelBuffer: CVPixelBuffer, rotation: Int, timeStamp: CMTime, isFront: Bool) {
        if isFront {
            for sessionWrapper in _captureSessionQueue {
                guard let session = sessionWrapper._session,
                      let onFrontFrameUpdateCallBack = session._onFrontFrameUpdateCallBack else {
                    continue
                }

                onFrontFrameUpdateCallBack(pixelBuffer, rotation)
            }

            for sessionWrapper in _observeCaptureSessionQueue {
                guard let session = sessionWrapper._session,
                      let onFrontFrameUpdateCallBack = session._onFrontFrameUpdateCallBack else {
                    continue
                }

                onFrontFrameUpdateCallBack(pixelBuffer, rotation)
            }
        }else {
            for sessionWrapper in _captureSessionQueue {
                guard let session = sessionWrapper._session,
                      let onRareFrameUpdateCallBack = session._onRareFrameUpdateCallBack else {
                    continue
                }

                onRareFrameUpdateCallBack(pixelBuffer, rotation)
            }

            for sessionWrapper in _observeCaptureSessionQueue {
                guard let session = sessionWrapper._session,
                      let onRareFrameUpdateCallBack = session._onRareFrameUpdateCallBack else {
                    continue
                }

                onRareFrameUpdateCallBack(pixelBuffer, rotation)
            }
        }
    }
}
