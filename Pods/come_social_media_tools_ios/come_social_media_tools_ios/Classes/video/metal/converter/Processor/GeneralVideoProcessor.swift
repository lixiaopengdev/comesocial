//
//  GeneralVideoProcessor.swift
//  come_social_media_tools_ios
//
//  Created by 于冬冬 on 2023/3/20.
//

import Foundation

public final class GeneralVideoProcessor: VideoProcessor {
    
    public init() {
        
    }
    
    var processor: VideoProcessor?
    {
        didSet {
            processor?.onCapturePixelBuffer(onCapturePixelBuffer: capturePixelBufferCallback)
        }
    }
    
    public func updateProcessorr(_ processor: VideoProcessor?) {
        self.processor = processor
    }
    
    var capturePixelBufferCallback: OnCapturePixelBuffer? {
        didSet {
            processor?.onCapturePixelBuffer(onCapturePixelBuffer: capturePixelBufferCallback)        }
    }
    
    public func update(inputPixelBuffer: CVPixelBuffer) {
        if let processor = processor {
            processor.update(inputPixelBuffer: inputPixelBuffer)
        } else {
            capturePixelBufferCallback?(inputPixelBuffer)
        }
    }
    
    public func onCapturePixelBuffer(onCapturePixelBuffer: OnCapturePixelBuffer?) {
        capturePixelBufferCallback = onCapturePixelBuffer
    }
  
}
