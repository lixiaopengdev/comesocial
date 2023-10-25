//
//  UIImage+Extensions.swift
//  comesocial
//
//  Created by 于冬冬 on 2022/12/9.
//

import UIKit


public extension UIImage {
    
    convenience init(color: UIColor, size: CGSize) {
        UIGraphicsBeginImageContextWithOptions(size, false, 1)
        defer {
            UIGraphicsEndImageContext()
        }

        color.setFill()
        UIRectFill(CGRect(origin: .zero, size: size))

        guard let aCgImage = UIGraphicsGetImageFromCurrentImageContext()?.cgImage else {
            self.init()
            return
        }

        self.init(cgImage: aCgImage)
    }
    
    convenience init?(pixelBuffer: CVPixelBuffer, orientation: UIImage.Orientation) {
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        let context = CIContext()
         let rect = CGRect(x: 0, y: 0, width: CVPixelBufferGetWidth(pixelBuffer),
                                                          height: CVPixelBufferGetHeight(pixelBuffer))
        guard let aCgImage = context.createCGImage(ciImage, from: rect) else {
            return nil
        }
        self.init(cgImage: aCgImage, scale: 1, orientation: orientation)
    }
    
    func withRoundedCorners(radius: CGFloat? = nil) -> UIImage? {
        let maxRadius = min(size.width, size.height) / 2
        let cornerRadius: CGFloat
        if let radius = radius, radius > 0, radius <= maxRadius {
            cornerRadius = radius
        } else {
            cornerRadius = maxRadius
        }

        UIGraphicsBeginImageContextWithOptions(size, false, scale)

        let rect = CGRect(origin: .zero, size: size)
        UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).addClip()
        draw(in: rect)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    func cropped(to rect: CGRect) -> UIImage {
        guard rect.size.width <= size.width, rect.size.height <= size.height else { return self }
        let scaledRect = rect.applying(CGAffineTransform(scaleX: scale, y: scale))
        guard let image = cgImage?.cropping(to: scaledRect) else { return self }
        return UIImage(cgImage: image, scale: scale, orientation: imageOrientation)
    }
    
    // CGRect(x: 7, y: 7, width: 24, height: 24)
    func merge(overlayImage: UIImage, frame: CGRect) -> UIImage? {
        let canvasSize = self.size
        
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, 0.0)
        
        self.draw(in: CGRect(origin: .zero, size: canvasSize))
        
        let overlayRect = frame
        
        overlayImage.draw(in: overlayRect)
        
        let mergedImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return mergedImage
        
    }
}
