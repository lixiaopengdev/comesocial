//
//  FieldEntryContentView.swift
//  CSFieldModule
//
//  Created by 于冬冬 on 2023/5/17.
//

import Foundation
import CSUtilities

class FieldEntryContentView: UIView {
    
    var contentClickCallback: Action?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .random()
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(contentClick)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func contentClick() {
        contentClickCallback?()
    }
}
