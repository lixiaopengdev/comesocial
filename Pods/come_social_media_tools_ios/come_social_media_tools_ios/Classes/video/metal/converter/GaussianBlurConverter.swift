//
//  GaussianBlurConverter.swift
//  come_social_media_tools_ios
//
//  Created by fuhao on 2023/3/8.
//

import Foundation
import MetalPerformanceShaders
import CoreVideo

public class GaussianBlurConverter {
    var _onCapturePixelBuffer: OnCapturePixelBuffer?
    var _onCaptureMetalTexture: OnCaptureMetalTexture?
    var _textureCache: CVMetalTextureCache?
    var _commandQueue: MTLCommandQueue?
    var _gaussianBlurKernel: MPSUnaryImageKernel?
    let _inFlightSemaphore = DispatchSemaphore(value: MetalShared.kMaxBuffersInFlight)
    var _outputPixelBufferPool: CVPixelBufferPool?
    
    var _NV12ToRGBConverter: NV12ToRGBConverter?
    
    var _excuteQueue: DispatchQueue?
    
    public init(sigma: Float) {
        guard let device = MTLCreateSystemDefaultDevice() else {
            return
        }
        _excuteQueue = DispatchQueue(label: "GaussianBlurConverter")
        initMetal(device: device)
        _gaussianBlurKernel = MPSImageGaussianBlur(device: device, sigma: sigma)
        _gaussianBlurKernel?.edgeMode = .clamp

    }
    
    func initMetal(device: MTLDevice) {
        var metalTextureCache: CVMetalTextureCache?
        guard CVMetalTextureCacheCreate(kCFAllocatorDefault, nil, device, nil, &metalTextureCache) == kCVReturnSuccess else {
            print("Unable to allocate depth converter texture cache")
            return
        }
        _textureCache = metalTextureCache
        // 创建命令队列
        _commandQueue = device.makeCommandQueue()
    }
    
    
    
    
    func createPixelBufferPool(source: MTLTexture) -> CVPixelBufferPool? {
        if let outputPixelBufferPool = _outputPixelBufferPool {
            return outputPixelBufferPool
        }
        
        _outputPixelBufferPool =  NV12ToRGBConverter.allocateOutputBufferPool(width: source.width, height: source.height, outputRetainedBufferCountHint: 2)
        return _outputPixelBufferPool
        
    }

    func createPixeBufferAndTexturePair(outputPixelBufferPool: CVPixelBufferPool,textureCache: CVMetalTextureCache) -> TexBufferPair?{
        var newPixelBuffer: CVPixelBuffer?
        CVPixelBufferPoolCreatePixelBuffer(kCFAllocatorDefault, outputPixelBufferPool, &newPixelBuffer)
        if let outputPixelBuffer = newPixelBuffer,
           let outputTexture = createTexture(fromPixelBuffer: outputPixelBuffer, textureCache: textureCache, pixelFormat: .bgra8Unorm, planeIndex: 0) {
            return TexBufferPair(outPutTexture: outputTexture, outPixelBuffer: outputPixelBuffer)
        }
        return nil
    }
    
    func createTexture(fromPixelBuffer pixelBuffer: CVPixelBuffer, textureCache: CVMetalTextureCache, pixelFormat: MTLPixelFormat, planeIndex: Int) -> MTLTexture? {
        guard CVPixelBufferLockBaseAddress(pixelBuffer, .readOnly) == kCVReturnSuccess else {
            return nil
        }
        defer {
            CVPixelBufferUnlockBaseAddress(pixelBuffer, .readOnly)
        }
        
        
        
        let width = CVPixelBufferGetWidthOfPlane(pixelBuffer, planeIndex)
        let height = CVPixelBufferGetHeightOfPlane(pixelBuffer, planeIndex)

        var cvTextureOut: CVMetalTexture? = nil
        let status = CVMetalTextureCacheCreateTextureFromImage(nil, textureCache, pixelBuffer, nil, pixelFormat, width, height, planeIndex, &cvTextureOut)
        guard status == kCVReturnSuccess,
              let cvTexture = cvTextureOut,
              let texture = CVMetalTextureGetTexture(cvTexture) else {
            CVMetalTextureCacheFlush(textureCache, 0)
            
            return nil
        }
        
        return texture
    }
}


extension GaussianBlurConverter : VideoConverterProtocol {
    private func _update(inputPixelBuffer: CVPixelBuffer) {
        
        
        guard let textureCache = _textureCache,
              let gaussianBlurKernel = _gaussianBlurKernel,
              (_onCapturePixelBuffer != nil || _onCaptureMetalTexture != nil ),
              let inputTexture = createTexture(fromPixelBuffer: inputPixelBuffer, textureCache: textureCache, pixelFormat: .bgra8Unorm, planeIndex: 0),
              let outputPixelBufferPool = createPixelBufferPool(source: inputTexture),
              let texBufferPair = createPixeBufferAndTexturePair(outputPixelBufferPool: outputPixelBufferPool, textureCache: textureCache) else {
            return
        }
        let outputPixelBuffer = texBufferPair.outPixelBuffer
        let outputTexture = texBufferPair.outPutTexture
        
        
        
        let _ = _inFlightSemaphore.wait(timeout: DispatchTime.distantFuture)
        guard let commandQueue = _commandQueue,
              let commandBuffer = commandQueue.makeCommandBuffer() else {
            _inFlightSemaphore.signal()
            return
        }
        
        commandBuffer.addCompletedHandler { [weak self] commanBuffer in
            guard let converter = self else {
                return
            }
            converter._inFlightSemaphore.signal()
            if let dataDelegate = converter._onCaptureMetalTexture {
                dataDelegate(outputTexture)
            }
            if let dataDelegate = converter._onCapturePixelBuffer {
                dataDelegate(outputPixelBuffer)
            }
        
            
            
        }
        
        commandBuffer.label = "GaussianBlur"
        gaussianBlurKernel.encode(commandBuffer: commandBuffer, sourceTexture: inputTexture, destinationTexture: outputTexture)
        commandBuffer.commit()
    }
    
    public func update(inputPixelBuffer: CVPixelBuffer) {
        let format = CVPixelBufferGetPixelFormatType(inputPixelBuffer)
        if format == kCVPixelFormatType_420YpCbCr8Planar || format == kCVPixelFormatType_420YpCbCr8PlanarFullRange
            || format == kCVPixelFormatType_422YpCbCr_4A_8BiPlanar || format == kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange
            || format == kCVPixelFormatType_420YpCbCr8BiPlanarFullRange {
            
            if _NV12ToRGBConverter == nil {
                guard let device = MTLCreateSystemDefaultDevice() else {
                    return
                }
                _NV12ToRGBConverter = NV12ToRGBConverter(device: device)
                _NV12ToRGBConverter?.onCaptureMetalTexture(onCaptureMetalTexture: { [weak self] texture in
                    self?.update(inputTexture: texture)
                })
            }
            
            _NV12ToRGBConverter?.update(inputPixelBuffer: inputPixelBuffer)
            
        }else if format == kCVPixelFormatType_32ARGB || format == kCVPixelFormatType_32BGRA
                    || format == kCVPixelFormatType_32ABGR || format == kCVPixelFormatType_32RGBA {
            _excuteQueue?.async { [weak self] in
                guard let convert = self else {
                    return
                }
                
                convert._update(inputPixelBuffer: inputPixelBuffer)
            }
        }else{
            fatalError("暂不支持的格式")
        }
        
        


    }
    
    private func _update(inputTexture: MTLTexture) {
        guard let textureCache = _textureCache,
              let gaussianBlurKernel = _gaussianBlurKernel,
              (_onCapturePixelBuffer != nil || _onCaptureMetalTexture != nil ),
              let outputPixelBufferPool = createPixelBufferPool(source: inputTexture),
              let texBufferPair = createPixeBufferAndTexturePair(outputPixelBufferPool: outputPixelBufferPool, textureCache: textureCache) else {
            return
        }
        let outputPixelBuffer = texBufferPair.outPixelBuffer
        let outputTexture = texBufferPair.outPutTexture
        
        
        
        let _ = _inFlightSemaphore.wait(timeout: DispatchTime.distantFuture)
        guard let commandQueue = _commandQueue,
              let commandBuffer = commandQueue.makeCommandBuffer() else {
            _inFlightSemaphore.signal()
            return
        }
        
        commandBuffer.addCompletedHandler { [weak self] commanBuffer in
            guard let converter = self else {
                return
            }
            converter._inFlightSemaphore.signal()
            
            if let dataDelegate = converter._onCaptureMetalTexture {
                dataDelegate(outputTexture)
            }
            if let dataDelegate = converter._onCapturePixelBuffer {
                dataDelegate(outputPixelBuffer)
            }
            
        }
        
        commandBuffer.label = "GaussianBlur"
        gaussianBlurKernel.encode(commandBuffer: commandBuffer, sourceTexture: inputTexture, destinationTexture: outputTexture)
        commandBuffer.commit()
    }
    
    //TODO: - 这些方法可以被重构
    public func update(inputTexture: MTLTexture) {
        _excuteQueue?.async { [weak self] in
            guard let convert = self else {
                return
            }
            
            convert._update(inputTexture: inputTexture)
        }
        
    }
    
    public func onCapturePixelBuffer(onCapturePixelBuffer: OnCapturePixelBuffer?) {
        _onCapturePixelBuffer = onCapturePixelBuffer
    }
    
    public func onCaptureMetalTexture(onCaptureMetalTexture: OnCaptureMetalTexture?) {
        _onCaptureMetalTexture = onCaptureMetalTexture
    }
    
    
}
