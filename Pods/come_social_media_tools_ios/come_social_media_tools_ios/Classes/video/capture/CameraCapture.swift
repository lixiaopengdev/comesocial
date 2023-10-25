//
//  CameraCapture.swift
//  ComeSocialRTCService_Example
//
//  Created by fuhao on 2023/1/19.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation


import UIKit
import AVFoundation

public protocol CameraCapturePushDelegate {
    func cameraFrameCapture(pixelBuffer: CVPixelBuffer, rotation: Int, timeStamp: CMTime, isFront: Bool)
}

public enum Camera: Int {
    case front = 1
    case back = 0
    
    static func defaultCamera() -> Camera {
        return .front
    }
    
    func next() -> Camera {
        switch self {
        case .back: return .front
        case .front: return .back
        }
    }
}

class CameraCapture: NSObject {
    
    fileprivate var delegate: CameraCapturePushDelegate?
    
    private let captureQueue: DispatchQueue
    private var currentCamera:Camera? = nil
    private var captureSession: AVCaptureSession?
    private var currentOutput: AVCaptureVideoDataOutput?
    
    
    init(delegate: CameraCapturePushDelegate?) {
        self.delegate = delegate
        captureQueue = DispatchQueue(label: "MyCaptureQueue")
    }
    
    deinit {
        captureSession?.stopRunning()
        captureSession = nil
    }
    
    func getOutput() -> AVCaptureVideoDataOutput? {
       guard let captureSession = self.captureSession else {
           return nil
       }
        if let outputs = captureSession.outputs as? [AVCaptureVideoDataOutput] {
           return outputs.first
       } else {
           return nil
       }
    }
    
    public func startCapture(ofCamera camera: Camera) {
        
        let captureSession = AVCaptureSession()
        self.captureSession = captureSession
        captureSession.usesApplicationAudioSession = true
        
        let captureOutput = AVCaptureVideoDataOutput()
        captureOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_420YpCbCr8BiPlanarFullRange]
        
        if captureSession.canAddOutput(captureOutput) {
            captureSession.addOutput(captureOutput)
        }
        
        let currentOutput = getOutput()
        self.currentOutput = currentOutput
        currentCamera = camera
        
        guard let currentOutput = currentOutput else {
            return
        }
        
        currentOutput.setSampleBufferDelegate(self, queue: captureQueue)
        
        captureQueue.async { [weak self] in
            guard let strongSelf = self,
                  let captureSession = strongSelf.captureSession else {
                return
            }
            strongSelf.changeCaptureDevice(toIndex: camera.rawValue, ofSession: captureSession)
            captureSession.beginConfiguration()
            if captureSession.canSetSessionPreset(AVCaptureSession.Preset.vga640x480) {
                captureSession.sessionPreset = AVCaptureSession.Preset.vga640x480
            }
            captureSession.commitConfiguration()
            captureSession.startRunning()
        }
    }
    
    public func stopCapture() {
        currentOutput?.setSampleBufferDelegate(nil, queue: nil)
        currentOutput = nil
        self.captureSession?.stopRunning()
        self.captureSession = nil
    }
    
   public func switchCamera() {
       stopCapture()
       if let currentCamera = currentCamera {
           self.currentCamera = currentCamera.next()
       }
        
       startCapture(ofCamera: self.currentCamera ?? .front)
    }
}

private extension CameraCapture {
    func changeCaptureDevice(toIndex index: Int, ofSession captureSession: AVCaptureSession) {
        guard let captureDevice = captureDevice(atIndex: index) else {
            return
        }
        
        let currentInputs = captureSession.inputs as? [AVCaptureDeviceInput]
        let currentInput = currentInputs?.first
        
        if let currentInputName = currentInput?.device.localizedName,
            currentInputName == captureDevice.uniqueID {
            return
        }
        
        guard let newInput = try? AVCaptureDeviceInput(device: captureDevice) else {
            return
        }
        
    
        
        captureSession.beginConfiguration()
        if let currentInput = currentInput {
            captureSession.removeInput(currentInput)
        }
        if captureSession.canAddInput(newInput) {
            captureSession.addInput(newInput)
        }
        captureSession.commitConfiguration()
    }
    
    func captureDevice(atIndex index: Int) -> AVCaptureDevice? {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .unspecified)
        let devices = deviceDiscoverySession.devices
        
        let count = devices.count
        guard count > 0, index >= 0 else {
            return nil
        }
        
        let device: AVCaptureDevice
        if index >= count {
            device = devices.last!
        } else {
            device = devices[index]
        }
        
        return device
    }
}

extension CameraCapture: AVCaptureVideoDataOutputSampleBufferDelegate {
    public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        let time = CMSampleBufferGetPresentationTimeStamp(sampleBuffer)
        switch self.currentCamera {
        case .front:
            delegate?.cameraFrameCapture(pixelBuffer: pixelBuffer, rotation: 90, timeStamp: time, isFront: true)
            break
        case .back:
            delegate?.cameraFrameCapture(pixelBuffer: pixelBuffer, rotation: 90, timeStamp: time, isFront: false)
            break
        case .none:
            break
        }
    }
}
