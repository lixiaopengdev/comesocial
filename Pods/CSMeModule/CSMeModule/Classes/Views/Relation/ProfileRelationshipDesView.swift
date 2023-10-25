//
//  ProfileRelationshipDesView.swift
//  CSMeModule
//
//  Created by 于冬冬 on 2023/5/16.
//

import Foundation

class ProfileRelationshipDesView: UIButton {

    init(_ des: String, right: Bool) {
        super.init(frame: .zero)
        
        titleLabel?.font = .boldBody
        setTitleColor(.cs_pureWhite, for: .normal)
        setTitleColor(.cs_lightGrey, for: .disabled)
        setTitle(des, for: .normal)
        setImage(UIImage.bundleImage(named: "button_icon_green_yes"), for: .normal)
        setImage(UIImage.bundleImage(named: "button_icon_red_no"), for: .disabled)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: -5)
        imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 5)
        isEnabled = right
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
