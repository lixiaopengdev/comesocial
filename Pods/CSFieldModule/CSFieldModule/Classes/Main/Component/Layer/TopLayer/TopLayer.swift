//
//  TopLayer.swift
//  Alamofire
//
//  Created by 于冬冬 on 2023/1/17.
//


import UIKit
import SnapKit
import CSUtilities

class TopLayer: FieldBaseView {
    
//    var lbButtons: LBButtons {
//        assembly.resolve()
//    }
    var cardStack: CardStackView{
        assembly.resolve()
    }

    override func initialize() {
        backgroundColor = .clear
//        addSubview(lbButtons)
        addSubview(cardStack)
        
//        lbButtons.snp.makeConstraints { make in
//            make.left.equalTo(34)
//            make.bottom.equalTo(-34)
//        }
//        cardStack.snp.makeConstraints { make in
//            make.right.equalToSuperview()
//            make.bottom.equalTo(lbButtons.snp.bottom)
//            make.height.equalTo(70)
//            make.left.equalTo(lbButtons.snp.right)
//        }
        
        cardStack.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
            make.height.equalTo(70)
            make.left.equalToSuperview()
        }
    }
    
    
    @objc private func showMessageView() {
        
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        if view == self {
            return nil
        }
        return view
        
    }
    
}
