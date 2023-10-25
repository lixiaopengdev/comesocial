//
//  CoverLayer.swift
//  Alamofire
//
//  Created by 于冬冬 on 2023/2/6.
//

import Foundation
class CoverLayer: FieldBaseView {
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        if view == self {
            return nil
        }
        return view
    }
}
