//
//  FragementStackView.swift
//  CSFriendsModule
//
//  Created by 于冬冬 on 2023/3/15.
//

import CSLogger

class FragementStackView: UIStackView {
    override init(frame: CGRect) {
        super.init(frame: frame)
//        backgroundColor = .random()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func clear() {
        for subView in arrangedSubviews {
            subView.removeFromSuperview()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        logger.info(size)
        return size
    }
}
