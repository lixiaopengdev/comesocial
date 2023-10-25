//
//  RenderView.swift
//  ComeSocialRTCService_Example
//
//  Created by fuhao on 2023/1/19.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation

import Metal
import MetalKit

public class SizeAdaptiveYUVRenderView: UIView {


    fileprivate var textures: [MTLTexture]?
    fileprivate var bgraTexture: MTLTexture?
    
    fileprivate var vertexBuffer: MTLBuffer?
    fileprivate var viewSize = CGSize.zero

    fileprivate var device = MTLCreateSystemDefaultDevice()
    fileprivate var yuvRenderPipelineState: MTLRenderPipelineState?
    fileprivate var rgbRenderPipelineState: MTLRenderPipelineState?
    fileprivate let semaphore = DispatchSemaphore(value: 2)
    fileprivate var metalDevice = MTLCreateSystemDefaultDevice()
    fileprivate var metalView: MTKView!
    fileprivate var textureCache: CVMetalTextureCache?
    fileprivate var commandQueue: MTLCommandQueue?
    

    public var userId: UInt = 0

    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 256, height: 256))
        initializeMetalView()
        initializeTextureCache()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeMetalView()
        initializeTextureCache()
    }

    override init(frame frameRect: CGRect) {
        super.init(frame: frameRect)
        initializeMetalView()
        initializeTextureCache()
    }

    public override var bounds: CGRect {
        didSet {
            viewSize = bounds.size
        }
    }

    public func startRender(_ uid: UInt = 0) {
        userId = uid
        metalView.delegate = self
    }

    public func stopRender() {
        userId = 0
        metalView.delegate = nil
    }
    
    

    public func renderVideoFrame(pixelBuffer: CVPixelBuffer,rotation: Int) {
        guard let rotation = getVideoRotation(rotation: rotation) else {
            return
        }

        guard CVPixelBufferLockBaseAddress(pixelBuffer, .readOnly) == kCVReturnSuccess else {
            return
        }
        defer {
            CVPixelBufferUnlockBaseAddress(pixelBuffer, .readOnly)
        }

        let isPlanar = CVPixelBufferIsPlanar(pixelBuffer)
        let width = isPlanar ? CVPixelBufferGetWidthOfPlane(pixelBuffer, 0) : CVPixelBufferGetWidth(pixelBuffer)
        let height = isPlanar ? CVPixelBufferGetHeightOfPlane(pixelBuffer, 0) : CVPixelBufferGetHeight(pixelBuffer)
        let size = CGSize(width: width, height: height)


        if let renderedCoordinates = rotation.renderedCoordinates(mirror: false,
                                                                  videoSize: size,
                                                                  viewSize: viewSize) {
            let byteLength = 4 * MemoryLayout.size(ofValue: renderedCoordinates[0])
            vertexBuffer = device?.makeBuffer(bytes: renderedCoordinates, length: byteLength, options: [.storageModeShared])
        }
        
        
        if isPlanar {
            initializeYUVRenderPipelineState()
            self.bgraTexture = nil
            if let yTexture = createTexture(pixelBuffer: pixelBuffer, textureCache: textureCache, planeIndex: 0, pixelFormat: .r8Unorm),
               let uvTexture = createTexture(pixelBuffer: pixelBuffer, textureCache: textureCache, planeIndex: 1, pixelFormat: .rg8Unorm) {
                self.textures = [yTexture, uvTexture]
            }
        }else {
            initializeRGBRenderPipelineState()
            self.textures = nil
            if let bgraTexture = createTexture(pixelBuffer: pixelBuffer, textureCache: textureCache, planeIndex: 0, pixelFormat: .bgra8Unorm) {
                self.bgraTexture = bgraTexture
            }
        }
    }
}

func getVideoRotation(rotation: Int) -> VideoRotation? {
    switch rotation {
    case 0:
        return .rotationNone
    case 90:
        return .rotation90
    case 180:
        return .rotation180
    case 270:
        return .rotation270
    default:
        return nil
    }
}


private extension SizeAdaptiveYUVRenderView {
    func initializeMetalView() {
        print(bounds)
        viewSize = bounds.size
        metalView = MTKView(frame: bounds, device: device)
        metalView.framebufferOnly = true
        metalView.colorPixelFormat = .bgra8Unorm
        metalView.contentScaleFactor = UIScreen.main.scale
        metalView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(metalView)
        commandQueue = device?.makeCommandQueue()
    }

    func initializeYUVRenderPipelineState() -> MTLRenderPipelineState? {
        guard let device = device else {
            return nil
        }
        
        if let yuvRenderPipelineState = yuvRenderPipelineState {
            return yuvRenderPipelineState
        }

        let frameworkBundle = Bundle(for: type(of: self))
        let metalLibraryPath = frameworkBundle.path(forResource: "default", ofType: "metallib")!
        guard let defaultLibrary = try? device.makeLibrary(filepath:metalLibraryPath) else {
            fatalError("加载Shader 失败")
        }

        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.sampleCount = 1
        pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        pipelineDescriptor.depthAttachmentPixelFormat = .invalid

        pipelineDescriptor.vertexFunction = defaultLibrary.makeFunction(name: "mapTexture_v1")
        pipelineDescriptor.fragmentFunction = defaultLibrary.makeFunction(name: "displayNV12Texture_v1")

        yuvRenderPipelineState = try? device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        
        return yuvRenderPipelineState
    }
    
    func initializeRGBRenderPipelineState() -> MTLRenderPipelineState? {
        guard let device = device else {
            return nil
        }
        
        if let rgbRenderPipelineState = rgbRenderPipelineState {
            return rgbRenderPipelineState
        }

        let frameworkBundle = Bundle(for: type(of: self))
        let metalLibraryPath = frameworkBundle.path(forResource: "default", ofType: "metallib")!
        guard let defaultLibrary = try? device.makeLibrary(filepath:metalLibraryPath) else {
            fatalError("加载Shader 失败")
        }

        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.sampleCount = 1
        pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        pipelineDescriptor.depthAttachmentPixelFormat = .invalid

        pipelineDescriptor.vertexFunction = defaultLibrary.makeFunction(name: "mapTexture_v1")
        pipelineDescriptor.fragmentFunction = defaultLibrary.makeFunction(name: "displayRGBTexture_v1")

        rgbRenderPipelineState = try? device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        
        return rgbRenderPipelineState
    }

    func initializeTextureCache() {
        guard let metalDevice = metalDevice,
            CVMetalTextureCacheCreate(kCFAllocatorDefault, nil, metalDevice, nil, &textureCache) == kCVReturnSuccess else {
            return
        }
    }
    
    

    func createTexture(pixelBuffer: CVPixelBuffer, textureCache: CVMetalTextureCache?, planeIndex: Int = 0, pixelFormat: MTLPixelFormat = .bgra8Unorm) -> MTLTexture? {
        guard let textureCache = textureCache, CVPixelBufferLockBaseAddress(pixelBuffer, .readOnly) == kCVReturnSuccess else {
            return nil
        }
        defer {
            CVPixelBufferUnlockBaseAddress(pixelBuffer, .readOnly)
        }

        let isPlanar = CVPixelBufferIsPlanar(pixelBuffer)
        let width = isPlanar ? CVPixelBufferGetWidthOfPlane(pixelBuffer, planeIndex) : CVPixelBufferGetWidth(pixelBuffer)
        let height = isPlanar ? CVPixelBufferGetHeightOfPlane(pixelBuffer, planeIndex) : CVPixelBufferGetHeight(pixelBuffer)
        

        var imageTexture: CVMetalTexture?
        let result = CVMetalTextureCacheCreateTextureFromImage(kCFAllocatorDefault, textureCache, pixelBuffer, nil, pixelFormat, width, height, planeIndex, &imageTexture)

        guard let unwrappedImageTexture = imageTexture,
            let texture = CVMetalTextureGetTexture(unwrappedImageTexture),
            result == kCVReturnSuccess
            else {
                return nil
        }

        return texture
    }
}

extension SizeAdaptiveYUVRenderView: MTKViewDelegate {
    public func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {

    }

    public func draw(in: MTKView) {
        guard viewSize.width > 0 && viewSize.height > 0 else {
            return
        }

        _ = semaphore.wait(timeout: .distantFuture)
        
    
        guard let device = device,
              let commandBuffer = commandQueue?.makeCommandBuffer(),
              let vertexBuffer = vertexBuffer else {
                semaphore.signal()
                return
        }
        
        if let textures = textures {
            renderForYUV(textures: textures, withCommandBuffer: commandBuffer, device: device, vertexBuffer: vertexBuffer)
            return
        }
        
        if let texture = bgraTexture {
            renderForRGB(rgbTexture: texture, withCommandBuffer: commandBuffer, device: device, vertexBuffer: vertexBuffer)
            return
        }
        
        semaphore.signal()
    }

    private func renderForYUV(textures: [MTLTexture], withCommandBuffer commandBuffer: MTLCommandBuffer, device: MTLDevice, vertexBuffer: MTLBuffer) {
        guard let currentRenderPassDescriptor = metalView.currentRenderPassDescriptor,
            let currentDrawable = metalView.currentDrawable,
            let renderPipelineState = initializeYUVRenderPipelineState(),
            let encoder = commandBuffer.makeRenderCommandEncoder(descriptor: currentRenderPassDescriptor) else {
                semaphore.signal()
                return
        }

        encoder.pushDebugGroup("Custom-Render-Frame")
        encoder.setRenderPipelineState(renderPipelineState)
        encoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)

        if let textureY = textures.first, let textureUV = textures.last {
            encoder.setFragmentTexture(textureY, index: 0)
            encoder.setFragmentTexture(textureUV, index: 1)
            encoder.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: 4)
        }

        encoder.popDebugGroup()
        encoder.endEncoding()

        commandBuffer.addScheduledHandler { [weak self] (buffer) in
            self?.semaphore.signal()
        }
        commandBuffer.present(currentDrawable)
        commandBuffer.commit()
    }
    
    private func renderForRGB(rgbTexture: MTLTexture, withCommandBuffer commandBuffer: MTLCommandBuffer, device: MTLDevice, vertexBuffer: MTLBuffer) {
        guard let currentRenderPassDescriptor = metalView.currentRenderPassDescriptor,
            let currentDrawable = metalView.currentDrawable,
            let renderPipelineState = initializeRGBRenderPipelineState(),
            let encoder = commandBuffer.makeRenderCommandEncoder(descriptor: currentRenderPassDescriptor) else {
                semaphore.signal()
                return
        }

        encoder.pushDebugGroup("Custom-Render-Frame")
        encoder.setRenderPipelineState(renderPipelineState)
        encoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)

        encoder.setFragmentTexture(rgbTexture, index: 0)
        encoder.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: 4)

        encoder.popDebugGroup()
        encoder.endEncoding()

        commandBuffer.addScheduledHandler { [weak self] (buffer) in
            self?.semaphore.signal()
        }
        commandBuffer.present(currentDrawable)
        commandBuffer.commit()
    }
}


