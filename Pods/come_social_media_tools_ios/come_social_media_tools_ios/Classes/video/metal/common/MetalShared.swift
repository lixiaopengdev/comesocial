//
//  MetalShared.swift
//  come_social_media_tools_ios
//
//  Created by fuhao on 2023/2/8.
//

import Foundation
import CoreVideo

public typealias OnCapturePixelBuffer = (CVPixelBuffer) -> Void
public typealias OnCaptureMetalTexture = (MTLTexture) -> Void


internal struct TexBufferPair {
    let outPutTexture: MTLTexture
    let outPixelBuffer: CVPixelBuffer
}

public protocol VideoConverterProtocol {
    //input
    func update(inputPixelBuffer: CVPixelBuffer)
    func update(inputTexture: MTLTexture)
    
    
    //output
    func onCapturePixelBuffer(onCapturePixelBuffer: OnCapturePixelBuffer?)
    func onCaptureMetalTexture(onCaptureMetalTexture: OnCaptureMetalTexture?)
}



enum VideoRotation:Int {
    /** 0: No rotation */
    case rotationNone = 0
    /** 1: 90 degrees */
    case rotation90 = 1
    /** 2: 180 degrees */
    case rotation180 = 2
    /** 3: 270 degrees */
    case rotation270 = 3
}

extension VideoRotation {
    func renderedCoordinates(mirror: Bool, videoSize: CGSize, viewSize: CGSize) -> [simd_float4]? {
        guard viewSize.width > 0, viewSize.height > 0, videoSize.width > 0, videoSize.height > 0 else {
            return nil
        }

        let widthAspito: Float
        let heightAspito: Float
        if self == .rotation90 || self == .rotation270 {
            widthAspito = Float(videoSize.height / viewSize.width)
            heightAspito = Float(videoSize.width / viewSize.height)
        } else {
            widthAspito = Float(videoSize.width / viewSize.width)
            heightAspito = Float(videoSize.height / viewSize.height)
        }

        let x: Float
        let y: Float
        if widthAspito < heightAspito {
            x = 1
            y = heightAspito / widthAspito
        } else {
            x = widthAspito / heightAspito
            y = 1
        }

        let A = simd_float4(  x, -y, 0.0, 1.0 )
        let B = simd_float4( -x, -y, 0.0, 1.0 )
        let C = simd_float4(  x,  y, 0.0, 1.0 )
        let D = simd_float4( -x,  y, 0.0, 1.0 )

        switch self {
        case .rotationNone:
            if mirror {
                return [A, B, C, D]
            } else {
                return [B, A, D, C]
            }
        case .rotation90:
            if mirror {
                return [C, A, D, B]
            } else {
                return [D, B, C, A]
            }
        case .rotation180:
            if mirror {
                return [D, C, B, A]
            } else {
                return [C, D, A, B]
            }
        case .rotation270:
            if mirror {
                return [B, D, A, C]
            } else {
                return [A, C, B, D]
            }
        }
    }
}


class MetalShared {
    // 平面的顶点数据（显示相机）
    internal static let kImagePlaneVertexData: [Float] = [
        -1.0, -1.0, 0.0, 0.0,
        1.0, -1.0,1.0, 0.0,
        -1.0,  1.0, 0.0, 1.0,
        1.0,  1.0,1.0, 1.0,
    ]
    
    
    // 平面的顶点数据（显示相机）
    internal static let kImagePlaneVertexData2: [Float] = [
        -1.0, -1.0,  0.0, 1.0,
        1.0, -1.0,  1.0, 1.0,
        -1.0,  1.0,  0.0, 0.0,
        1.0,  1.0,  1.0, 0.0,
    ]
    
    
    // 命令缓冲区同时处理的最大数量
    internal static let kMaxBuffersInFlight: Int = 2
}
