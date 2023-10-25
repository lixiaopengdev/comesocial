//
//  MutiCameraCapture.swift
//  come_social_media_tools_ios
//
//  Created by fuhao on 2023/3/7.
//

import Foundation


private enum SessionSetupResult {
    case success
    case notAuthorized
    case configurationFailed
    case multiCamNotSupported
}



class MutiCameraCapture : NSObject {
    
//    private let sessionQueue = DispatchQueue(label: "session queue")
    fileprivate var delegate: CameraCapturePushDelegate?
    private let dataOutputQueue = DispatchQueue(label: "data output queue")
    
    private let backCameraVideoDataOutput = AVCaptureVideoDataOutput()
    private let frontCameraVideoDataOutput = AVCaptureVideoDataOutput()
    
    private let session = AVCaptureMultiCamSession()
    private var setupResult: SessionSetupResult = .success

    @objc dynamic private(set) var backCameraDeviceInput: AVCaptureDeviceInput?
    
    
    private var frontCameraDeviceInput: AVCaptureDeviceInput?
    
    init(delegate: CameraCapturePushDelegate?) {
        self.delegate = delegate
        super.init()
        configureSession()
    }
    
    private func configureSession() {
        guard setupResult == .success else { return }
        
        guard AVCaptureMultiCamSession.isMultiCamSupported else {
            print("MultiCam not supported on this device")
            setupResult = .multiCamNotSupported
            return
        }
        
        // When using AVCaptureMultiCamSession, it is best to manually add connections from AVCaptureInputs to AVCaptureOutputs
        session.beginConfiguration()
        defer {
            session.commitConfiguration()
            if setupResult == .success {
//                checkSystemCost()
            }
        }

        guard configureBackCamera() else {
            setupResult = .configurationFailed
            return
        }
        
        guard configureFrontCamera() else {
            setupResult = .configurationFailed
            return
        }
    }
    
    private func configureBackCamera() -> Bool {
        session.beginConfiguration()
        defer {
            session.commitConfiguration()
        }
        
        // Find the back camera
        guard let backCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            print("Could not find the back camera")
            return false
        }
        
        // Add the back camera input to the session
        do {
            backCameraDeviceInput = try AVCaptureDeviceInput(device: backCamera)
            
            guard let backCameraDeviceInput = backCameraDeviceInput,
                session.canAddInput(backCameraDeviceInput) else {
                    print("Could not add back camera device input")
                    return false
            }
            session.addInputWithNoConnections(backCameraDeviceInput)
        } catch {
            print("Could not create back camera device input: \(error)")
            return false
        }
        
        // Find the back camera device input's video port
        guard let backCameraDeviceInput = backCameraDeviceInput,
            let backCameraVideoPort = backCameraDeviceInput.ports(for: .video,
                                                              sourceDeviceType: backCamera.deviceType,
                                                              sourceDevicePosition: backCamera.position).first else {
                                                                print("Could not find the back camera device input's video port")
                                                                return false
        }
        
        // Add the back camera video data output
        guard session.canAddOutput(backCameraVideoDataOutput) else {
            print("Could not add the back camera video data output")
            return false
        }
        session.addOutputWithNoConnections(backCameraVideoDataOutput)
        // Check if CVPixelFormat Lossy or Lossless Compression is supported
        
        if backCameraVideoDataOutput.availableVideoPixelFormatTypes.contains(kCVPixelFormatType_Lossy_420YpCbCr8BiPlanarFullRange) {
            // Set the Lossy format
            print("Selecting lossy pixel format")
            backCameraVideoDataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_Lossy_420YpCbCr8BiPlanarFullRange)]
        } else if backCameraVideoDataOutput.availableVideoPixelFormatTypes.contains(kCVPixelFormatType_Lossless_420YpCbCr8BiPlanarFullRange) {
            // Set the Lossless format
            print("Selecting a lossless pixel format")
            backCameraVideoDataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_Lossless_420YpCbCr8BiPlanarFullRange)]
        } else {
            // Set to the fallback format
            print("Selecting a 420YpCbCr8BiPlanar pixel format")
            backCameraVideoDataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)]
        }
        
        backCameraVideoDataOutput.setSampleBufferDelegate(self, queue: dataOutputQueue)
        
        // Connect the back camera device input to the back camera video data output
        let backCameraVideoDataOutputConnection = AVCaptureConnection(inputPorts: [backCameraVideoPort], output: backCameraVideoDataOutput)
        guard session.canAddConnection(backCameraVideoDataOutputConnection) else {
            print("Could not add a connection to the back camera video data output")
            return false
        }
        session.addConnection(backCameraVideoDataOutputConnection)
//        backCameraVideoDataOutputConnection.videoOrientation = .portrait

        
        return true
    }
    
    private func configureFrontCamera() -> Bool {
        session.beginConfiguration()
        defer {
            session.commitConfiguration()
        }
        
        // Find the front camera
        guard let frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
            print("Could not find the front camera")
            return false
        }
        
        // Add the front camera input to the session
        do {
            frontCameraDeviceInput = try AVCaptureDeviceInput(device: frontCamera)
            
            guard let frontCameraDeviceInput = frontCameraDeviceInput,
                session.canAddInput(frontCameraDeviceInput) else {
                    print("Could not add front camera device input")
                    return false
            }
            session.addInputWithNoConnections(frontCameraDeviceInput)
        } catch {
            print("Could not create front camera device input: \(error)")
            return false
        }
        
        // Find the front camera device input's video port
        guard let frontCameraDeviceInput = frontCameraDeviceInput,
            let frontCameraVideoPort = frontCameraDeviceInput.ports(for: .video,
                                                                    sourceDeviceType: frontCamera.deviceType,
                                                                    sourceDevicePosition: frontCamera.position).first else {
                                                                        print("Could not find the front camera device input's video port")
                                                                        return false
        }
        
        // Add the front camera video data output
        guard session.canAddOutput(frontCameraVideoDataOutput) else {
            print("Could not add the front camera video data output")
            return false
        }
        session.addOutputWithNoConnections(frontCameraVideoDataOutput)
        // Check if CVPixelFormat Lossy or Lossless Compression is supported
        
        if frontCameraVideoDataOutput.availableVideoPixelFormatTypes.contains(kCVPixelFormatType_Lossy_420YpCbCr8BiPlanarFullRange) {
            // Set the Lossy format
            frontCameraVideoDataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_Lossy_420YpCbCr8BiPlanarFullRange)]
        } else if frontCameraVideoDataOutput.availableVideoPixelFormatTypes.contains(kCVPixelFormatType_Lossless_420YpCbCr8BiPlanarFullRange) {
            // Set the Lossless format
            frontCameraVideoDataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_Lossless_420YpCbCr8BiPlanarFullRange)]
        } else {
            // Set to the fallback format
            frontCameraVideoDataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)]
        }

        frontCameraVideoDataOutput.setSampleBufferDelegate(self, queue: dataOutputQueue)
        
        // Connect the front camera device input to the front camera video data output
        let frontCameraVideoDataOutputConnection = AVCaptureConnection(inputPorts: [frontCameraVideoPort], output: frontCameraVideoDataOutput)
        guard session.canAddConnection(frontCameraVideoDataOutputConnection) else {
            print("Could not add a connection to the front camera video data output")
            return false
        }
        session.addConnection(frontCameraVideoDataOutputConnection)
//        frontCameraVideoDataOutputConnection.videoOrientation = .portrait
//        frontCameraVideoDataOutputConnection.automaticallyAdjustsVideoMirroring = false
        frontCameraVideoDataOutputConnection.isVideoMirrored = true

        
        return true
    }
}


extension MutiCameraCapture {
    func startCapturing() {
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized:
                if !self.session.isRunning {
                    self.session.startRunning()
                }
                return
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    if granted {
                        if !self.session.isRunning {
                            self.session.startRunning()
                        }
                    }
                }

            case .denied:
                return

            case .restricted:
                return
            @unknown default:
                return
        }
        
        
        

    }
    
    func stopCapturing() {
        if session.isRunning {
            session.stopRunning()
        }
    }
}

extension MutiCameraCapture: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if let videoDataOutput = output as? AVCaptureVideoDataOutput {
            processVideoSampleBuffer(sampleBuffer, fromOutput: videoDataOutput)
        }
    }
    
    private func processVideoSampleBuffer(_ sampleBuffer: CMSampleBuffer, fromOutput videoDataOutput: AVCaptureVideoDataOutput) {
        guard let samplePixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer),
            let formatDescription = CMSampleBufferGetFormatDescription(sampleBuffer) else {
                return
        }
        let time = CMSampleBufferGetPresentationTimeStamp(sampleBuffer)
        
        if videoDataOutput == backCameraVideoDataOutput {
            delegate?.cameraFrameCapture(pixelBuffer: samplePixelBuffer, rotation: 90, timeStamp: time, isFront: false)
        } else if videoDataOutput == frontCameraVideoDataOutput {
            delegate?.cameraFrameCapture(pixelBuffer: samplePixelBuffer, rotation: 270, timeStamp: time, isFront: true)
        }
    }
}
