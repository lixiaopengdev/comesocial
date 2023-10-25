//
//  FaceTimeClient.swift
//  CSFriendsModule
//
//  Created by 于冬冬 on 2023/2/7.
//

import Foundation
import CSNetwork
import come_social_media_tools_ios
import ComeSocialRTCService
import Combine
import CSLogger
import CSFileKit
import CSUtilities

protocol FaceTimeClientObserver: AnyObject {
    func updateBuffer(pixelBuffer: CVPixelBuffer, rotation: Int)
    func updateFrontBuffer(pixelBuffer: CVPixelBuffer, rotation: Int)
}

class FaceTimeClient: NSObject, FieldComponent {
    
//    struct VideoStatus: OptionSet {
//        let rawValue: Int
//
//        static let faceTime: VideoStatus = VideoStatus(rawValue: 1 << 0)
//        static let photo: VideoStatus = VideoStatus(rawValue: 1 << 1)
//    }
    
    let assembly: FieldAssembly
    
    var rtcClient: RTCClient {
        return assembly.resolve()
    }
    
    var observers:[WeakWrapper<FaceTimeClientObserver>] = []
//    @Published var status: VideoStatus = []
    
//    private weak var channel: RTCChannel?

    
    var onCapturePhotoChange = PassthroughSubject<String?, Never>()
//    var onBufferSubject = PassthroughSubject<(pixelBuffer: CVPixelBuffer, rotation: Int), Never>()
//    var onFrontBufferSubject = PassthroughSubject<(pixelBuffer: CVPixelBuffer, rotation: Int), Never>()

    var videoCapture: CSCaptureSession?
    @Published private(set) var isFront = true
    //    var videoProcessor: GeneralVideoProcessor = GeneralVideoProcessor()
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    var isOpen: Bool {
        return videoCapture != nil
    }
    
//    func start() {
//        status.insert(.faceTime)
//    }
//    func stop() {
//        status.remove(.faceTime)
//    }
    
    func addObserver(_ ob: FaceTimeClientObserver) {
        
        observers.append(WeakWrapper(ob))
        clearNilObserver()
        cheackStatus()
    }
    
    func removeObserver(_ ob: FaceTimeClientObserver) {
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
    
    func updateBuffer(pixelBuffer: CVPixelBuffer, rotation: Int) {
        for observer in observers {
            var clearEmpty = false
            if let value = observer.value {
                value.updateBuffer(pixelBuffer: pixelBuffer, rotation: rotation)
            } else {
                clearEmpty = true
            }
            if clearEmpty {
                clearNilObserver()
            }
        }
    }
    
    func updateFrontBuffer(pixelBuffer: CVPixelBuffer, rotation: Int) {
        for observer in observers {
            var clearEmpty = false
            if let value = observer.value {
                value.updateFrontBuffer(pixelBuffer: pixelBuffer, rotation: rotation)
            } else {
                clearEmpty = true
            }
            if clearEmpty {
                clearNilObserver()
            }
        }
    }
    
    func cheackStatus() {
        if observers.isEmpty {
            if isOpen {
                stopVideo()
            }
        } else {
            if !isOpen {
                startVideo()
            }
        }
    }
    
    required init(assembly: FieldAssembly) {
        self.assembly = assembly
        super.init()
        //        assembly.usersManager().mine.$isRendering.removeDuplicates().sink { [weak self] rendering in
        //            if rendering {
        //                self?.status.insert(.faceTime)
        //            } else {
        //                self?.status.remove(.faceTime)
        //            }
        //        }.store(in: &cancellableSet)
        
        //        $status.map({ $0.isEmpty }).removeDuplicates().sink(receiveValue: { [weak self] empty in
        //            if empty {
        //                self?.stopVideo()
        //            } else {
        //                self?.startVideo()
        //            }
        //        }).store(in: &cancellableSet)
        
        //        rtcClient.$channel.sink { [weak self] channel in
        //            self?.channel = channel
        //        }.store(in: &cancellableSet)
        
        //        videoProcessor.onCapturePixelBuffer { [weak self] buffer in
        //            self?.update(pixelBuffer: buffer)
        //        }
        
//        $isFront
//            .removeDuplicates()
//            .sink { value in
//
//            }.store(in: &cancellableSet)
        
    }
    
    
    func capturePhoto() {
//        if status.contains(.photo) {
//            return
//        }
//        status.insert(.photo)
//        onBufferSubject.compactMap({ return $0 }).output(at: 10).sink { [weak self] buffer in
//            self?.saveImage(pixelBuffer: buffer.pixelBuffer)
//            self?.status.remove(.photo)
//        }.store(in: &cancellableSet)
    }
    
    
    func saveImage(pixelBuffer: CVPixelBuffer) {
        
        Task {[weak self] in
            do {
                let image = UIImage(pixelBuffer: pixelBuffer, orientation: .right)
                let localUrl = try await FileTask.saveImage(image: image)
                let serveUrl = try await UploadTask.uploadImage(path: localUrl)
                await MainActor.run {
                    onCapturePhotoChange.send(serveUrl)
                }
            } catch {
                self?.onCapturePhotoChange.send(nil)
                
            }
        }
    }
    
    
    
    func changeEffect(name: String) {
        
        HUD.showError("video is null")
        
//        if !isOpen {
//            HUD.showError("video is closed")
//            return
//        }
        //        videoProcessor.updateProcessorr(GaussianBlurConverter(sigma: 0.5))
    }
    
    private func startVideo() {
        if videoCapture == nil {
            forceOpenVideo()
        }
    }
    
    func switchCamera() {
        isFront = !isFront
        if videoCapture != nil {
            forceOpenVideo()
        }
    }
    
    func forceOpenVideo() {
                
        let frontCamera = isFront ? CSCameraCaptureConfig(frame: true, arTrack: false) : nil
        let rareCamera = !isFront ? CSCameraCaptureConfig(frame: true, arTrack: false) : nil

        let config = CSCaptureSessionConfig(frontCamera: frontCamera, rareCamera: rareCamera)
        videoCapture = ARAndCameraCaptureService.sharedInstance.openCaptureSession(config: config)
        
        videoCapture?.onCaptureFrontCamera({ [weak self] frame, rotation in
            self?.updateFrontBuffer(pixelBuffer: frame, rotation: rotation)
        })
        videoCapture?.onCaptureRareCamera({ [weak self] frame, rotation in
            self?.updateBuffer(pixelBuffer: frame, rotation: rotation)
        })
    }
    
    private func stopVideo() {
        videoCapture?.onCaptureRareCamera(nil)
        videoCapture?.onCaptureFrontCamera(nil)
        videoCapture = nil
    }
    
    func willDestory() {
        stopVideo()
    }
    
    deinit {
        print("FaceTimeClient deinit")
    }
    
}






//相机采集回调
//extension FaceTimeClient {
//
//    public func update(pixelBuffer: CVPixelBuffer, rotation: Int) {
////        self.rotation = rotation
////        lastBuffer = pixelBuffer
////        onBufferSubject.send((pixelBuffer: pixelBuffer, rotation: rotation))
//
//        //发送到频道
////        if let channel = channel {
////            channel.sendVideoFrame(pixelBuffer: pixelBuffer,rotation: rotation)
////        }
//
//    }
//
//    //    func update(pixelBuffer: CVPixelBuffer) {
//    //        onBufferSubject.send((pixelBuffer: pixelBuffer, rotation: rotation))
//    //        //本地渲染
//    ////        localRenderView?.renderVideoFrame(pixelBuffer: pixelBuffer, rotation: rotation)
//    //        //发送到频道
//    //        if let channel = channel {
//    //            channel.sendVideoFrame(pixelBuffer: pixelBuffer,rotation: rotation)
//    //        }
//    //    }
//}
