//
//  ProfileHeaderNameCell.swift
//  CSListView
//
//  Created by 于冬冬 on 2023/6/13.
//

import Foundation

final class ProfileHeaderBioCell: UICollectionViewCell {
    
    private static let bioFont = UIFont.regularSubheadline

    static func bioHeight(bio: String, width: CGFloat) -> CGFloat {
        let bioH: CGFloat = (bio.calculateHeight(width: width - 36, font: bioFont))
        return bioH
    }
    
    let bioLabel: UILabel = {
        let label = UILabel()
        label.textColor = .cs_pureWhite
        label.font = ProfileHeaderBioCell.bioFont
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        contentView.addSubview(bioLabel)
        
        bioLabel.snp.makeConstraints { make in
            make.left.equalTo(18)
            make.right.equalTo(-18)
            make.top.equalTo(0)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
