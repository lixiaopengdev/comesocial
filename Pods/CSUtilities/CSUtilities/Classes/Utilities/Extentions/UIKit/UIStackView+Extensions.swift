//
//  UIStackView+Extensions.swift
//  CSUtilities
//
//  Created by 于冬冬 on 2023/5/23.
//

import Foundation

public extension UIStackView {
    
    func removeArrangedSubviews() {
        for view in arrangedSubviews {
            removeArrangedSubview(view)
        }
    }
    
    func addArrangedSubviews(_ views: [UIView]) {
        for view in views {
            addArrangedSubview(view)
        }
    }
}
