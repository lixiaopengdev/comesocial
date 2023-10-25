//
//  Button.swift
//  CSFriendsModule
//
//  Created by 于冬冬 on 2023/3/21.
//

import UIKit

class Button: UIButton {
    
    private var originalColor: UIColor?
    private let activityIndicatorView = UIActivityIndicatorView(style: .white)
    var isLoading: Bool = false {
        didSet {
            if isLoading {
                titleLabel?.alpha = 0
                isEnabled = false
                self.addSubview(activityIndicatorView)
                activityIndicatorView.startAnimating()
            } else {
                titleLabel?.alpha = 1
                activityIndicatorView.removeFromSuperview()
                activityIndicatorView.stopAnimating()
                isEnabled = true
            }
        }
    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layerCornerRadius = 17
        setBackgroundColor(color: UIColor(hex: 0xe6556d), forState: .normal)
        contentEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        activityIndicatorView.center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
    }
}
