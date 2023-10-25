//
//  NoticeCell.swift
//  CSListView
//
//  Created by 于冬冬 on 2023/6/12.
//


import Foundation
import CSUtilities

protocol NoticeCellDelegate: AnyObject {
    func noticeCellDidTapButton(_ cell: NoticeCell)
}

final class NoticeCell: UICollectionViewCell {
    
    weak var delegate: NoticeCellDelegate?

    let backgroundRect: UIView = {
        let view = UIView()
        view.backgroundColor = .cs_3D3A66_40
        view.layerCornerRadius = 10
        return view
    }()
    
    let contentLabel: UILabel = {
        let label = UILabel()
        label.textColor = .cs_pureWhite
        label.font = .regularSubheadline
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()

    let iconImageView: UIImageView = UIImageView()
    
    lazy var viewBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setBackgroundColor(color: UIColor.cs_decoMidPurple, forState: .normal)
        button.setTitleColor(.cs_pureWhite, for: .normal)
        button.titleLabel?.font = .regularSubheadline
        button.setTitle("View", for: .normal)
        button.layerCornerRadius = 6
        button.addTarget(self, action: #selector(onViewButton(_:)), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        iconImageView.contentMode = .scaleAspectFill
        iconImageView.layerCornerRadius = 18
        
        contentView.addSubview(backgroundRect)
        
        backgroundRect.addSubview(contentLabel)
        backgroundRect.addSubview(iconImageView)
        backgroundRect.addSubview(viewBtn)
        
        backgroundRect.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12))
        }
        iconImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(14)
            make.size.equalTo(36)
        }
        contentLabel.snp.makeConstraints { make in
            make.left.equalTo(iconImageView.snp.right).offset(10)
            make.right.equalTo(-95)
            make.top.bottom.equalToSuperview()
        }
        viewBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(-14)
            make.size.equalTo(CGSize(width: 61, height: 32))
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func onViewButton(_ button: UIButton) {
        delegate?.noticeCellDidTapButton(self)
    }
}
