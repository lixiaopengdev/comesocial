//
//  TitleCell.swift
//  CSListView
//
//  Created by 于冬冬 on 2023/6/13.
//

final class TitleCell: UICollectionViewCell {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .cs_pureWhite
        label.font = .boldTitle1
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        addSubview(titleLabel)

        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(18)
            make.right.equalTo(-18)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
