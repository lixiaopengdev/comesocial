//
//  TimeDewZoneView.swift
//  CSListView
//
//  Created by fuhao on 2023/6/20.
//

import UIKit

class TimeDewZoneView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupView() {
        self.backgroundColor = .cs_3D3A66_40
    }
    
    func top() {
        self.layer.cornerRadius = 10
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    func fill() {
        self.layer.cornerRadius = 0
    }
    
    func bottom() {
        self.layer.cornerRadius = 10
        self.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    func both() {
        self.layer.cornerRadius = 10
    }
    
}
