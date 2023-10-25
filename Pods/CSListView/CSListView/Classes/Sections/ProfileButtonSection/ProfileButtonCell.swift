//
//  ProfileButtonCell.swift
//  CSListView
//
//  Created by 于冬冬 on 2023/6/13.
//

import Foundation
import CSCommon

protocol ProfileButtonCellDelegate: AnyObject {
    func profileButtonCellDidTapButton(_ cell: ProfileButtonCell)
}

final class ProfileButtonCell: UICollectionViewCell {
    
    weak var delegate: ProfileButtonCellDelegate?
    
    lazy var fieldBtn: CSGradientButton = {
        let button = CSGradientButton(type: .custom)
        button.setBackgroundImage(UIImage(color: .cs_3D3A66_40, size: CGSize(width: 1, height: 1)), for: .disabled)
        button.imageTextSpacing = 8
        button.setTitleColor(.cs_softWhite2, for: .normal)
        button.layerCornerRadius = 12
        button.titleLabel?.font = .boldBody
        button.addTarget(self, action: #selector(onFieldButton(_:)), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        contentView.addSubview(fieldBtn)

        fieldBtn.snp.makeConstraints { make in
            make.left.equalTo(18)
            make.right.equalTo(-18)
            make.height.equalTo(50)
        }
    }
    
    @objc func onFieldButton(_ button: UIButton) {
        delegate?.profileButtonCellDidTapButton(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
