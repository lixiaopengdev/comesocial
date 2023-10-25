//
//  WidgetFragmentProtocol.swift
//  CSFriendsModule
//
//  Created by 于冬冬 on 2023/3/15.
//

import Foundation
import Combine
import SwiftyJSON
import CSLogger

class WidgetFragmentView: UIView {

    var cancellableSet: Set<AnyCancellable> = []
    let fragment: WidgetFragment
    var assembly: FieldAssembly {
        fragment.assembly
    }
    
    required init(fragment: WidgetFragment) {
        self.fragment = fragment
        super.init(frame: .zero)
//        backgroundColor = .cs_cardColorA_20
//        backgroundColor = .random()
        layerCornerRadius = 24
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialize() {
        
    }
    
    override var intrinsicContentSize: CGSize {
        logger.info(CGSize(width: UIView.noIntrinsicMetric, height: fragment.height))

        return CGSize(width: UIView.noIntrinsicMetric, height: fragment.height)
    }
    
    
}

