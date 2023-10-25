//
//  FieldSearchCell.swift
//  CSFieldModule
//
//  Created by 于冬冬 on 2023/4/14.
//

import Foundation
import CSUtilities

class FieldSearchCell: UITableViewCell {
    
    let backgroundRect: UIView = {
        let view = UIView()
        view.backgroundColor = .cs_3D3A66_20
        view.layerCornerRadius = 12
        return view
    }()
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .cs_pureWhite
        label.font = .regularHeadline
        return label
    }()
    
    let subNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .cs_decoLightPurple
        label.font = .regularFootnote
        return label
    }()
    
    let desLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    

    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(backgroundRect)
        
        backgroundRect.addSubview(nameLabel)
        backgroundRect.addSubview(subNameLabel)
        backgroundRect.addSubview(desLabel)
        backgroundRect.addSubview(iconImageView)

        backgroundRect.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 5, left: 18, bottom: 5, right: 18))
        }
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(14)
            make.top.equalTo(12)
        }
        subNameLabel.snp.makeConstraints { make in
            make.left.equalTo(14)
            make.top.equalTo(nameLabel.snp.bottom).offset(2)
        }
        desLabel.snp.makeConstraints { make in
            make.left.equalTo(14)
            make.top.equalTo(subNameLabel.snp.bottom).offset(10)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.right.equalTo(-9)
            make.bottom.equalToSuperview()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateField(_ field: FieldModel) {
        nameLabel.text = "Cathy Pink’ Field"
        subNameLabel.text = "Simple Text Field"
        
        let d1 = NSAttributedString(string: "Aaron and Blake ").foregroundColor(.cs_primaryPink).font(.regularSubheadline)
        let d2 = NSAttributedString(string: "are here ").foregroundColor(.cs_softWhite2).font(.regularSubheadline)
        desLabel.attributedText = d1 + d2
        iconImageView.image = UIImage.bundleImage(named: "field_search_icon_2")
    }
    
}
