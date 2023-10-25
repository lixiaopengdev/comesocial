//
//  StaticSectionView.swift
//  CSMeModule
//
//  Created by 于冬冬 on 2023/5/8.
//

import UIKit

class StaticSectionView: UITableViewHeaderFooterView {

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .cs_softWhite
        label.font = .boldBody
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateTitle(_ title: String?) {
        titleLabel.text = title
    }
}
