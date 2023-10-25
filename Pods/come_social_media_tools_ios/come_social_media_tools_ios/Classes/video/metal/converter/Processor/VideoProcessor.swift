//
//  VideoProcessor.swift
//  come_social_media_tools_ios
//
//  Created by 于冬冬 on 2023/3/20.
//

import Foundation

public protocol VideoProcessor: AnyObject {
    func update(inputPixelBuffer: CVPixelBuffer)
    func onCapturePixelBuffer(onCapturePixelBuffer: OnCapturePixelBuffer?)
    
}

extension GaussianBlurConverter: VideoProcessor {

    
}
