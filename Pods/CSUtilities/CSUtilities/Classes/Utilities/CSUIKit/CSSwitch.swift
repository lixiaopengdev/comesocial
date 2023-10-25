//
//  CSSwitch.swift
//  CSMeModule
//
//  Created by 于冬冬 on 2023/5/10.
//

import Foundation

public class CSSwitch: UISwitch {
    var offTintColor: UIColor = .cs_lightGrey
    {
        didSet {
            backgroundColor = offTintColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        onTintColor = .cs_primaryPink
        backgroundColor = offTintColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        layerCornerRadius = frame.height / 2
    }
    
}
