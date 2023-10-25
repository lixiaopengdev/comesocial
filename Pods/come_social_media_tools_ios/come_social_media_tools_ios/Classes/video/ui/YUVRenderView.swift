//
//  RenderView.swift
//  ComeSocialRTCService_Example
//
//  Created by fuhao on 2023/2/9.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import MetalKit

public class YUVRenderView : UIView {

    fileprivate var metalView: MTKView!
    var converter: NV12ToRGBConverter?
    var renderer: MetalViewRenderer?
    public let userId: UInt
    
    public init(uid: UInt) {
        userId = uid
        super.init(frame: CGRect(x: 0, y: 0, width: 256, height: 256))
        initializeMetalView()
    }

    required init?(uid: UInt,coder aDecoder: NSCoder) {
        userId = uid
        super.init(coder: aDecoder)
        initializeMetalView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initializeMetalView() {
        print(bounds)
        guard let device = MTLCreateSystemDefaultDevice() else {
            return
        }
        
        metalView = MTKView(frame: bounds, device: device)
        metalView.framebufferOnly = true
        metalView.delegate = self
        metalView.colorPixelFormat = .bgra8Unorm
        metalView.contentScaleFactor = UIScreen.main.scale
        metalView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(metalView)
        
        renderer = MetalViewRenderer()
        renderer?.renderToView(renderView: metalView)
        
        converter = NV12ToRGBConverter(device: device)
        converter?.onCapturePixelBuffer(onCapturePixelBuffer: {[weak self] buffer in
            guard let renderView = self else {
                return
            }
            renderView.renderer?.pushPixelBuffer(source: buffer)
        })
    }

//    public var kCVPixelFormatType_420YpCbCr8Planar: OSType { get } /* Planar Component Y'CbCr 8-bit 4:2:0.  baseAddr points to a big-endian CVPlanarPixelBufferInfo_YCbCrPlanar struct */
//    public var kCVPixelFormatType_420YpCbCr8PlanarFullRange: OSType { get } /* Planar Component Y'CbCr 8-bit 4:2:0, full range.  baseAddr points to a big-endian CVPlanarPixelBufferInfo_YCbCrPlanar struct */
//    public var kCVPixelFormatType_422YpCbCr_4A_8BiPlanar: OSType { get } /* First plane: Video-range Component Y'CbCr 8-bit 4:2:2, ordered Cb Y'0 Cr Y'1; second plane: alpha 8-bit 0-255 */
//    public var kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange: OSType { get } /* Bi-Planar Component Y'CbCr 8-bit 4:2:0, video-range (luma=[16,235] chroma=[16,240]).  baseAddr points to a big-endian CVPlanarPixelBufferInfo_YCbCrBiPlanar struct */
//    public var kCVPixelFormatType_420YpCbCr8BiPlanarFullRange: OSType { get } /* Bi-Planar Component Y'CbCr 8-bit 4:2:0,
    
    public func renderVideoFrame(pixelBuffer: CVPixelBuffer, rotation: Int) {
        let format = CVPixelBufferGetPixelFormatType(pixelBuffer)
        if format == kCVPixelFormatType_420YpCbCr8Planar || format == kCVPixelFormatType_420YpCbCr8PlanarFullRange
            || format == kCVPixelFormatType_422YpCbCr_4A_8BiPlanar || format == kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange
            || format == kCVPixelFormatType_420YpCbCr8BiPlanarFullRange {
            converter?.update(inputPixelBuffer: pixelBuffer)
        }else if format == kCVPixelFormatType_32ARGB || format == kCVPixelFormatType_32BGRA
                    || format == kCVPixelFormatType_32ABGR || format == kCVPixelFormatType_32RGBA{
            renderer?.pushPixelBuffer(source: pixelBuffer)
        }else{
            fatalError("暂不支持的格式")
        }
    }
    
}


extension YUVRenderView: MTKViewDelegate {
    public func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {

    }

    public func draw(in: MTKView) {
        guard let renderer = renderer else {
            return
        }
        renderer.processRender()
    }

   
}
