//
//  NV12ToRGBConverter.swift
//  come_social_media_tools_ios
//
//  Created by fuhao on 2023/2/8.
//

import Foundation


import Foundation
import Metal
import MetalKit





//NV12 to BGRA
public class NV12ToRGBConverter {
    let _inFlightSemaphore = DispatchSemaphore(value: MetalShared.kMaxBuffersInFlight)
    var _onCapturePixelBuffer: OnCapturePixelBuffer?
    var _onCaptureMetalTexture: OnCaptureMetalTexture?

    // Metal objects
    var _commandQueue: MTLCommandQueue?
    var _texturePlaneVertexBuffer: MTLBuffer?
    var _pipelineState: MTLRenderPipelineState?
    var _textureCache: CVMetalTextureCache?
    var _renderTargetDesc: MTLRenderPassDescriptor?
    var _outputPixelBufferPool: CVPixelBufferPool?


    var _excuteQueue: DispatchQueue?
    

    public init(device: MTLDevice) {
        print("NV12ToRGBConverter 创建")
        _excuteQueue = DispatchQueue(label: "NV12ToRGBConverter")
        loadMetal(device: device)
    }

    deinit {
        print("NV12ToRGBConverter 释放")
    }
    
    
    static internal func allocateOutputBufferPool(width: Int, height: Int, outputRetainedBufferCountHint: Int) -> CVPixelBufferPool? {
        let outputPixelBufferAttributes: [String: Any] = [
            kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA,
            kCVPixelBufferWidthKey as String: width,
            kCVPixelBufferHeightKey as String: height,
            kCVPixelBufferIOSurfacePropertiesKey as String: [:]
        ]

        let poolAttributes = [kCVPixelBufferPoolMinimumBufferCountKey as String: outputRetainedBufferCountHint]
        var cvPixelBufferPool: CVPixelBufferPool?
        CVPixelBufferPoolCreate(kCFAllocatorDefault, poolAttributes as NSDictionary?, outputPixelBufferAttributes as NSDictionary?, &cvPixelBufferPool)
        guard let pixelBufferPool = cvPixelBufferPool else {
            assertionFailure("Allocation failure: Could not create pixel buffer pool")
            return nil
        }
        return pixelBufferPool
    }
    

    

}



//MARK: - API
extension NV12ToRGBConverter : VideoConverterProtocol{
    public func update(inputTexture: MTLTexture) {
        
    }
    
    private func _update(inputPixelBuffer: CVPixelBuffer) {
        guard let textureCache = _textureCache,
              let pipelineState = _pipelineState,
              let rgbaRenderTargetDesc = _renderTargetDesc,
              (_onCapturePixelBuffer != nil || _onCaptureMetalTexture != nil ),
              let rgbaColorAttachment = rgbaRenderTargetDesc.colorAttachments[0],
              let yTexture = createTexture(fromPixelBuffer: inputPixelBuffer, textureCache: textureCache, pixelFormat: .r8Unorm, planeIndex: 0),
              let uvTexture = createTexture(fromPixelBuffer: inputPixelBuffer, textureCache: textureCache, pixelFormat: .rg8Unorm, planeIndex: 1),
              let outputPixelBufferPool = createPixelBufferPool(source: yTexture),
              let texBufferPair = createPixeBufferAndTexturePair(outputPixelBufferPool: outputPixelBufferPool, textureCache: textureCache) else {
            return
        }
        let outputPixelBuffer = texBufferPair.outPixelBuffer
        let outputTexture = texBufferPair.outPutTexture
        let textures = [yTexture, uvTexture]
        rgbaColorAttachment.texture = outputTexture
        
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

        if let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: rgbaRenderTargetDesc) {
            renderEncoder.label = "MyRenderEncoder"
            drawTextureCopy(textures: textures, renderEncoder: renderEncoder, pipelineState: pipelineState)
            renderEncoder.endEncoding()
        }
        
        
        commandBuffer.commit()
    }
    
    public func update(inputPixelBuffer: CVPixelBuffer) {
        
        _excuteQueue?.async { [weak self] in
            guard let converter = self else {
                return
            }
            
            converter._update(inputPixelBuffer: inputPixelBuffer)
        }
        
        
    }


    public func onCapturePixelBuffer(onCapturePixelBuffer: OnCapturePixelBuffer?) {
        _onCapturePixelBuffer = onCapturePixelBuffer
    }
    
    public func onCaptureMetalTexture(onCaptureMetalTexture: OnCaptureMetalTexture?) {
        _onCaptureMetalTexture = onCaptureMetalTexture
    }
}

//MARK: - Private
extension NV12ToRGBConverter {

    
    func createPixeBufferAndTexturePair(outputPixelBufferPool: CVPixelBufferPool,textureCache: CVMetalTextureCache) -> TexBufferPair?{
        var newPixelBuffer: CVPixelBuffer?
        CVPixelBufferPoolCreatePixelBuffer(kCFAllocatorDefault, outputPixelBufferPool, &newPixelBuffer)
        if let outputPixelBuffer = newPixelBuffer,
           let outputTexture = createTexture(fromPixelBuffer: outputPixelBuffer, textureCache: textureCache, pixelFormat: .bgra8Unorm, planeIndex: 0) {
            return TexBufferPair(outPutTexture: outputTexture, outPixelBuffer: outputPixelBuffer)
        }
        return nil
    }
    
    func createPixelBufferPool(source: MTLTexture) -> CVPixelBufferPool? {
        if let outputPixelBufferPool = _outputPixelBufferPool {
            return outputPixelBufferPool
        }
        
        _outputPixelBufferPool =  NV12ToRGBConverter.allocateOutputBufferPool(width: source.width, height: source.height, outputRetainedBufferCountHint: 2)
        return _outputPixelBufferPool
        
    }
    
    
    
    
    func loadMetal(device: MTLDevice) {
        var metalTextureCache: CVMetalTextureCache?
        if CVMetalTextureCacheCreate(kCFAllocatorDefault, nil, device, nil, &metalTextureCache) != kCVReturnSuccess {
            assertionFailure("Unable to allocate depth converter texture cache")
        } else {
            _textureCache = metalTextureCache
        }
        
        let renderTargetDesc = MTLRenderPassDescriptor()
        guard let rgbaColorAttachment = renderTargetDesc.colorAttachments[0] else {
            assertionFailure("ColorAttachment is nil")
            return
        }
        rgbaColorAttachment.loadAction = .clear
        rgbaColorAttachment.storeAction = .store
        rgbaColorAttachment.clearColor = MTLClearColorMake(0, 0, 0, 1)
        _renderTargetDesc = renderTargetDesc
        
        
        let defaultColorPixelFormat = MTLPixelFormat.bgra8Unorm
        let defaultSampleCount = 1

        // 用平面顶点数组创建一个顶点缓冲区。
        let imagePlaneVertexDataCount = MetalShared.kImagePlaneVertexData2.count * MemoryLayout<Float>.size
        _texturePlaneVertexBuffer = device.makeBuffer(bytes: MetalShared.kImagePlaneVertexData2, length: imagePlaneVertexDataCount, options: [])
        guard let copyTexturePlaneVertexBuffer = _texturePlaneVertexBuffer else {
            fatalError("makeBuffer create faild")
        }
        copyTexturePlaneVertexBuffer.label = "copyTexturePlaneVertexBuffer"

        // 加载项目下的 Shader
        let frameworkBundle = Bundle(for: type(of: self))
        let metalLibraryPath = frameworkBundle.path(forResource: "default", ofType: "metallib")!

        guard let defaultLibrary = try? device.makeLibrary(filepath:metalLibraryPath) else {
            fatalError("加载Shader 失败")
        }

        let capturedImageVertexFunction = defaultLibrary.makeFunction(name: "capturedImageVertexTransform")!
        let textureCopyFragmentFunction = defaultLibrary.makeFunction(name: "capturedImageFragmentShader")!

        // 为平面顶点缓冲器创建一个顶点描述符
        let imagePlaneVertexDescriptor = MTLVertexDescriptor()

        // Positions.
        imagePlaneVertexDescriptor.attributes[0].format = .float2
        imagePlaneVertexDescriptor.attributes[0].offset = 0
        imagePlaneVertexDescriptor.attributes[0].bufferIndex = Int(kBufferIndexMeshPositions_v1.rawValue)

        // Texture coordinates.
        imagePlaneVertexDescriptor.attributes[1].format = .float2
        imagePlaneVertexDescriptor.attributes[1].offset = 8
        imagePlaneVertexDescriptor.attributes[1].bufferIndex = Int(kBufferIndexMeshPositions_v1.rawValue)

        // Buffer Layout
        imagePlaneVertexDescriptor.layouts[0].stride = 16
        imagePlaneVertexDescriptor.layouts[0].stepRate = 1
        imagePlaneVertexDescriptor.layouts[0].stepFunction = .perVertex

        //创建一个纹理拷贝的渲染管线
        let copyToTexturePipelineStateDescriptor = MTLRenderPipelineDescriptor()
        copyToTexturePipelineStateDescriptor.label = "CopyToTexturePipeline"
        copyToTexturePipelineStateDescriptor.sampleCount = defaultSampleCount
        copyToTexturePipelineStateDescriptor.vertexFunction = capturedImageVertexFunction
        copyToTexturePipelineStateDescriptor.fragmentFunction = textureCopyFragmentFunction
        copyToTexturePipelineStateDescriptor.vertexDescriptor = imagePlaneVertexDescriptor
        copyToTexturePipelineStateDescriptor.colorAttachments[0].pixelFormat = defaultColorPixelFormat


        do {
            try _pipelineState = device.makeRenderPipelineState(descriptor: copyToTexturePipelineStateDescriptor)
        } catch let error {
            print("Failed to created captured image pipeline state, error \(error)")
        }

        // 创建命令队列
        _commandQueue = device.makeCommandQueue()
    }

//    func loadCacheTexture(width: Int, height: Int,device: MTLDevice) {
//        //创建输出的RGBA PixelBuffer
//        let options = [ kCVPixelBufferMetalCompatibilityKey as String: true,  kCVPixelBufferCGImageCompatibilityKey as String: true ] as [String: Any]
//        let status = CVPixelBufferCreate(kCFAllocatorDefault, width, height, kCVPixelFormatType_32BGRA, options as CFDictionary, &rgbaPixelBuffer)
//        if status != kCVReturnSuccess {
//            fatalError(status.description)
//        }
//
//
//
//
//        var metalTextureCache: CVMetalTextureCache?
//        if CVMetalTextureCacheCreate(kCFAllocatorDefault, nil, device, nil, &metalTextureCache) != kCVReturnSuccess {
//            assertionFailure("Unable to allocate depth converter texture cache")
//        } else {
//            textureCache = metalTextureCache
//        }
//
//
//        guard let rgbaPixelBuffer = rgbaPixelBuffer,
//              let rgbaTextureTextureCache = textureCache,
//              let texture = createTexture(fromPixelBuffer: rgbaPixelBuffer, textureCache: rgbaTextureTextureCache, pixelFormat: .bgra8Unorm, planeIndex: 0) else {
//            fatalError("createTexture is error")
//        }
//
////        let iiiiii = CIImage(cvPixelBuffer: rgbaPixelBuffer)
//
//        
//        //创建纹理到纹理的MTLRenderPassDescriptor

//    }

    //创建纹理
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

    //复制纹理
    func drawTextureCopy(textures: [MTLTexture], renderEncoder: MTLRenderCommandEncoder, pipelineState: MTLRenderPipelineState) {
        // 推送一个DebugGroup，允许我们在GPU帧捕获工具中识别渲染命令
        renderEncoder.pushDebugGroup("DrawCopyTexture")

        renderEncoder.setCullMode(.none)
        renderEncoder.setRenderPipelineState(pipelineState)
        renderEncoder.setVertexBuffer(_texturePlaneVertexBuffer, offset: 0, index: Int(kBufferIndexMeshPositions_v1.rawValue))
        
        if let textureY = textures.first, let textureUV = textures.last {
            renderEncoder.setFragmentTexture(textureY, index: Int(kTextureIndexY_v1.rawValue))
            renderEncoder.setFragmentTexture(textureUV, index: Int(kTextureIndexCbCr_v1.rawValue))
            renderEncoder.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: 4)
        }
        renderEncoder.popDebugGroup()
    }
    
    

}
