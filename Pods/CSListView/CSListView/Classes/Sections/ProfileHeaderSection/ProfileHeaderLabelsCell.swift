//
//  ProfileHeaderLabelsCell.swift
//  CSListView
//
//  Created by 于冬冬 on 2023/6/13.
//

final class ProfileHeaderLabelsCell: UICollectionViewCell {
    
    private let containerView = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        containerView.alignment = .center
        containerView.axis = .horizontal
        containerView.spacing = 7
        
        addSubview(containerView)
        
        containerView.snp.makeConstraints { make in
            make.left.equalTo(18)
            make.top.equalToSuperview()
            make.height.equalTo(22)
        }
        
    }
    
    func update(labels: [String]) {
        
        for view in containerView.arrangedSubviews {
            view.removeFromSuperview()
        }
        
        for label in labels {
            
            let btn = UIButton()
            btn.backgroundColor = .cs_3D3A66_40
            btn.setTitleColor(.cs_softWhite2, for: .normal)
            btn.layerCornerRadius = 11
            btn.titleLabel?.font = .regularFootnote
            btn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
            btn.setTitle(label, for: .normal)
            
            containerView.addArrangedSubview(btn)

            btn.snp.makeConstraints { make in
                make.height.equalTo(22)
            }
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

