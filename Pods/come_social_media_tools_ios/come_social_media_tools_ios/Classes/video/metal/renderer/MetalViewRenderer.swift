//
//  MetalRenderer.swift
//  ComeSocialDemo
//
//  Created by fuhao on 2022/9/21.
//

import Foundation
import Metal
import MetalKit


public protocol MetalViewRendererDelegate : AnyObject{
    func onPixelBufferFromTexture(_ pixelBuffer: CVPixelBuffer?)
}

//用于将bgra8Unorm MTTexture/CVPixelBuffer 渲染到视图上
public class MetalViewRenderer {
    weak var _renderView: MTKView?
    let inFlightSemaphore = DispatchSemaphore(value: MetalShared.kMaxBuffersInFlight)
    weak var _delegate: MetalViewRendererDelegate?
    

    // Metal objects
    var _commandQueue: MTLCommandQueue?
    var _texturePipelineState: MTLRenderPipelineState?
    var _texturePlaneVertexBuffer: MTLBuffer?
    var _textureCache: CVMetalTextureCache?
    var _sourceTexture: MTLTexture?
    var _outputTexture: MTLTexture?
    var _outputPixelBufferPool: CVPixelBufferPool?
    
    
    var _excuteQueue: DispatchQueue?
    var _texBufferPair:[TexBufferPair] = [TexBufferPair]()
    
    var _currentBuffer: Int = 0
    
    
    public init(){
        _excuteQueue = DispatchQueue(label: "MetalViewRenderer")
        
        
    }
    
    static private func allocateOutputBufferPool(width: Int, height: Int, outputRetainedBufferCountHint: Int) -> CVPixelBufferPool? {
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


// MARK: - API
extension MetalViewRenderer {
    public func setOutPixelBufferDelegate(delegate: MetalViewRendererDelegate){
        _delegate = delegate
    }
    
    public func renderToView(renderView: MTKView) {
        if let device = renderView.device {
            _renderView = renderView
            loadMetal(renderView: renderView,device: device)
        }else{
            guard let device = MTLCreateSystemDefaultDevice() else {
                return
            }
            
            renderView.device = device
            _renderView = renderView
            loadMetal(renderView: renderView,device: device)
        }
    }
    
    public func pushTexture(source: MTLTexture) {
        _sourceTexture = source
    }
    
    
    
    
    public func pushPixelBuffer(source: CVPixelBuffer) {
        guard let textureCache = createTextureCache(),
              let inputTexture = createTexture(fromPixelBuffer: source, textureCache: textureCache, pixelFormat: .bgra8Unorm, planeIndex: 0) else {
            return
        }

        pushTexture(source: inputTexture)
    }
    
    
    
    
    private func _processRender() {
        guard let source = _sourceTexture else {
            return
        }

        
        //仅输出结果
        guard let commandQueue = _commandQueue,
              let renderDestination = _renderView,
              let renderPassDescriptor = renderDestination.currentRenderPassDescriptor,
              let currentDrawable = renderDestination.currentDrawable,
              let texturePipelineState = _texturePipelineState else {
            renderTextureForPixelBuffer(source: source)
            return
        }
        
        
        
        var outputPixelBuffer :CVPixelBuffer?
        var outputTexture :MTLTexture?
        


        
        let _ = inFlightSemaphore.wait(timeout: DispatchTime.distantFuture)
        guard let commandBuffer = commandQueue.makeCommandBuffer() else {
            inFlightSemaphore.signal()
            return
        }
        
        
        //需要输出结果
        if _delegate != nil {
            guard let textureCache = _textureCache,
                  let outputPixelBufferPool = createPixelBufferPool(source: source),
                  let texBufferPairs = initTexturePair(textureCache: textureCache, outputPixelBufferPool: outputPixelBufferPool) else {
                _delegate = nil
                return
            }
            
            let texBufferPair = texBufferPairs[_currentBuffer]
            outputPixelBuffer = texBufferPair.outPixelBuffer
            outputTexture = texBufferPair.outPutTexture
        }
        
        commandBuffer.label = "MyCommand"
        commandBuffer.addCompletedHandler { [weak self] commandBuffer in
        
            guard let renderer = self else {
                return
            }
            let recordCurrentBuffer = renderer._currentBuffer
            renderer._currentBuffer = (renderer._currentBuffer + 1) % MetalShared.kMaxBuffersInFlight
            renderer.inFlightSemaphore.signal()
            

            guard let delegate = renderer._delegate else {
                return
            }
            let texBufferPair = renderer._texBufferPair[recordCurrentBuffer]
            delegate.onPixelBufferFromTexture(texBufferPair.outPixelBuffer)
            
        }
        

        
        //Draw #1
        if  let delegate = _delegate,
            let outPutTexture = outputTexture,
            let blitEncoder = commandBuffer.makeBlitCommandEncoder() {
            blitEncoder.copy(from: source, to: outPutTexture)
            blitEncoder.endEncoding()
        }
        
        //Draw #2
        if let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) {
            renderEncoder.label = "MyRenderEncoder"
            drawTextureCopy(sourceTexture: source, renderEncoder: renderEncoder, texturePipelineState: texturePipelineState)
            renderEncoder.endEncoding()
            commandBuffer.present(currentDrawable)
        }
        

        
        commandBuffer.commit()
    }
    
    public func processRender() {
        guard _sourceTexture != nil else {
            return
        }
        
        _excuteQueue?.async { [weak self] in
            guard let render = self else {
                return
            }
            
            render._processRender()
        }
    }
    
    public func processRenderMainThread() {
        _processRender()
    }
}


// MARK: - Private
extension MetalViewRenderer {
    func initTexturePair(textureCache: CVMetalTextureCache, outputPixelBufferPool: CVPixelBufferPool) -> [TexBufferPair]? {
        guard _texBufferPair.count != MetalShared.kMaxBuffersInFlight else {
            return _texBufferPair
        }
        
        for _ in 0..<MetalShared.kMaxBuffersInFlight {
            guard let texBufferPair = createPixeBufferAndTexturePair(outputPixelBufferPool: outputPixelBufferPool, textureCache: textureCache) else {
                _texBufferPair.removeAll()
                return nil
            }
            _texBufferPair.append(texBufferPair)
        }
        return _texBufferPair
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
    
    func createPixelBufferPool(source: MTLTexture) -> CVPixelBufferPool? {
        if let outputPixelBufferPool = _outputPixelBufferPool {
            return outputPixelBufferPool
        }
        
        _outputPixelBufferPool =  MetalViewRenderer.allocateOutputBufferPool(width: source.width, height: source.height, outputRetainedBufferCountHint: 2)
        return _outputPixelBufferPool
        
    }
    
    func renderTextureForPixelBuffer(source: MTLTexture) {
        guard let delegate = _delegate,
              let commandQueue = createCommandQueueForPixelBuffer(),
              let textureCache = createTextureCache(),
              let outputPixelBufferPool = createPixelBufferPool(source: source),
              let texBufferPairs = initTexturePair(textureCache: textureCache, outputPixelBufferPool: outputPixelBufferPool) else {
            resetMetal()
            _delegate = nil
            return
        }
        
        
        
        let _ = inFlightSemaphore.wait(timeout: DispatchTime.distantFuture)
        guard let commandBuffer = commandQueue.makeCommandBuffer() else {
            inFlightSemaphore.signal()
            return
        }
        commandBuffer.label = "MyCommand"
        
        
        let texBufferPair = texBufferPairs[_currentBuffer]
        let outputPixelBuffer = texBufferPair.outPixelBuffer
        commandBuffer.addCompletedHandler { [weak self] commandBuffer in
            
            guard let renderer = self else {
                return
            }
            let recordCurrentBuffer = renderer._currentBuffer
            renderer._currentBuffer = (renderer._currentBuffer + 1) % MetalShared.kMaxBuffersInFlight
            renderer.inFlightSemaphore.signal()
            
            let texBufferPair = renderer._texBufferPair[recordCurrentBuffer]
            
            guard let delegate = renderer._delegate else {
                return
            }
            delegate.onPixelBufferFromTexture(texBufferPair.outPixelBuffer)
            
            

        }
        
        if let blitEncoder = commandBuffer.makeBlitCommandEncoder() {
            blitEncoder.copy(from: source, to: texBufferPair.outPutTexture)
            blitEncoder.endEncoding()
        }

        commandBuffer.commit()
    }
    
    

    
    
    func createCommandQueueForPixelBuffer() -> MTLCommandQueue? {
        if _commandQueue != nil {
            return _commandQueue
        }
        
        guard let device = MTLCreateSystemDefaultDevice(),
              let commandQueue = device.makeCommandQueue() else{
            return nil
        }
        _commandQueue = commandQueue
        return _commandQueue
    }
    
    
    func createTextureCache() -> CVMetalTextureCache? {
        if let textureCache = _textureCache {
            return textureCache
        }
        
        guard let device = MTLCreateSystemDefaultDevice() else {
            assertionFailure("Unable to MTLCreateSystemDefaultDevice")
            return nil
        }
        
        var metalTextureCache: CVMetalTextureCache?
        if CVMetalTextureCacheCreate(kCFAllocatorDefault, nil, device, nil, &metalTextureCache) != kCVReturnSuccess {
            assertionFailure("Unable to allocate depth converter texture cache")
        } else {
            _textureCache = metalTextureCache
        }
        
        return _textureCache
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
    
    // 创建并初始化 Metal，初始化渲染数据缓冲区
    func loadMetal(renderView: MTKView, device: MTLDevice) {
        
        // 设置渲染目标（MTKView）所需的默认格式
        let defaultColorPixelFormat = MTLPixelFormat.bgra8Unorm
        let defaultSampleCount = 1
        renderView.colorPixelFormat = defaultColorPixelFormat
        renderView.sampleCount = defaultSampleCount
        

        // 用平面顶点数组创建一个顶点缓冲区。
        let imagePlaneVertexDataCount = MetalShared.kImagePlaneVertexData.count * MemoryLayout<Float>.size
        _texturePlaneVertexBuffer = device.makeBuffer(bytes: MetalShared.kImagePlaneVertexData, length: imagePlaneVertexDataCount, options: [])
        guard _texturePlaneVertexBuffer != nil else {
            resetMetal()
            return
        }

        // 加载项目下的 Shader
        let frameworkBundle = Bundle(for: type(of: self))
        let metalLibraryPath = frameworkBundle.path(forResource: "default", ofType: "metallib")!
        
        guard let defaultLibrary = try? device.makeLibrary(filepath:metalLibraryPath) else {
            assertionFailure("加载Shader 失败")
            resetMetal()
            return
        }

        let capturedImageVertexFunction = defaultLibrary.makeFunction(name: "capturedImageVertexTransform")!
        let textureCopyFragmentFunction = defaultLibrary.makeFunction(name: "textureCopyFragmentShader")!

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
            try _texturePipelineState = device.makeRenderPipelineState(descriptor: copyToTexturePipelineStateDescriptor)
        } catch let error {
            assertionFailure("Failed to created captured image pipeline state, error \(error)")
            resetMetal()
            return
        }

        // 创建命令队列
        _commandQueue = device.makeCommandQueue()
    }

    //复制纹理
    func drawTextureCopy(sourceTexture: MTLTexture, renderEncoder: MTLRenderCommandEncoder, texturePipelineState: MTLRenderPipelineState) {

        // 推送一个DebugGroup，允许我们在GPU帧捕获工具中识别渲染命令
        renderEncoder.pushDebugGroup("DrawCopyTexture")
        
        // 设置渲染命令编码器的状态
        renderEncoder.setCullMode(.none)
        renderEncoder.setRenderPipelineState(texturePipelineState)
        
        // 设置 Mesh 的顶点缓冲区
        renderEncoder.setVertexBuffer(_texturePlaneVertexBuffer, offset: 0, index: Int(kBufferIndexMeshPositions_v1.rawValue))
        
        // 设置渲染管道中采样的纹理
        renderEncoder.setFragmentTexture(sourceTexture, index: Int(kTextureIndexColor_v1.rawValue))
        
        
        // 绘制网格
        renderEncoder.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: 4)
        
        //推出DebugGroup
        renderEncoder.popDebugGroup()
    }
    
    
    func resetMetal() {
        _commandQueue = nil
        _texturePipelineState = nil
        _texturePlaneVertexBuffer = nil
    }
}
