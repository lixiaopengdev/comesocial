//
//  FaceTimeLayoutEngine.swift
//  comesocial
//
//  Created by 于冬冬 on 2022/11/22.
//

import Foundation
import CSUtilities

struct FaceTimeLayoutEngine {
    enum Style {
        case small
        case middle
        case large
    }
    
    static let containerSize: CGSize = {
        let width = WidgetFragment.widgetWidth
        let videoWidth = (width - 20) / 3
        let videoHeigh = videoWidth + 22
        let height = (videoHeigh + 10) * 3 - 10
        return CGSize(width: width, height: height)
    }()

    private(set) var faceCount: Int = 0
    private var layouts: [CGRect] = []
    private var containerSize: CGSize { return FaceTimeLayoutEngine.containerSize }
    
    
    var style: Style {
        switch faceCount {
        case 1:
            return .large
        case 2...4:
            return .middle
        default:
            return .small
        }
    }
    
    var area: CGRect = CGRect(origin: .zero, size: containerSize)
    
    mutating func change(face count: Int) {
        faceCount = count
        resizeLayout()
        if var initArea = layouts.first {
            for layout in layouts {
                initArea = initArea.union(layout)
            }
            area = initArea
        } else {
            area = CGRect(origin: .zero, size: containerSize)
        }
    }
    
    
    func getFaceFrame(index: Int) -> CGRect {
        return layouts[index]
    }
    
    private mutating func resizeLayout() {
        layouts.removeAll(keepingCapacity: true)
        
        let containerCenter = CGPoint(x: containerSize.width / 2, y: containerSize.height / 2)
        switch faceCount {
        case 1:
            let width = containerSize.width
            let height = width + 22
            layouts.append(CGRect(x: containerCenter.x - width / 2, y: containerCenter.y - width / 2, width: width, height: height))
            
        case 2:
            let width = (containerSize.width - 10) / 2
            let height = width + 22
            let distance = width + 10
            let rect1 = CGRect(x: 0, y: containerCenter.y - height / 2, width: width, height: height)
            let rect2 = rect1.offsetBy(dx: distance, dy: 0)
            layouts.append(rect1)
            layouts.append(rect2)
        case 3:
            let width = (containerSize.width - 10) / 2
            let distance = width + 10
            let height = width + 22
            let rect1 = CGRect(x: 0, y: containerCenter.y - 5 - height, width: width, height: height)
            let rect2 = rect1.offsetBy(dx: distance, dy: 0)
            let rect3 = CGRect(x: containerCenter.x - width / 2, y: containerCenter.y + 5, width: width, height: height)
            layouts.append(rect1)
            layouts.append(rect2)
            layouts.append(rect3)
        case 4:
            let width = (containerSize.width - 10) / 2
            let height = width + 22
            let distanceX = width + 10
            let distanceY = height + 10
            let rect1 = CGRect(x: 0, y: containerCenter.y - 5 - height, width: width, height: height)
            let rect2 = rect1.offsetBy(dx: distanceX, dy: 0)
            let rect3 = rect1.offsetBy(dx: 0, dy: distanceY)
            let rect4 = rect1.offsetBy(dx: distanceX, dy: distanceY)
            layouts.append(rect1)
            layouts.append(rect2)
            layouts.append(rect3)
            layouts.append(rect4)
        case 5...9:
            let width = (containerSize.width - 10 * 2) / 3
            let height = width + 22
            let distanceX = width + 10
            let distanceY = height + 10

            var rect1 = CGRect(x: 0, y: 0, width: width, height: height)
            if (faceCount <= 6) {
                rect1.origin.y = distanceY / 2
            }
            
            for index in 0..<faceCount {
                let dx = index % 3
                let dy = index / 3
                var xSpace: CGFloat = 0
                if faceCount == 5 && index >= 3 {
                    xSpace = distanceX / 2
                }
                if faceCount == 7 && index == 6 {
                    xSpace = distanceX
                }
                if faceCount == 8 && index >= 6 {
                    xSpace = distanceX / 2
                }
                layouts.append(rect1.offsetBy(dx: CGFloat(dx) * distanceX + xSpace, dy: CGFloat(dy) * distanceY))
            }
        default:
            break
        }
        layouts = layouts.map({ $0.integral })
    }
}
