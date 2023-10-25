//
//  FoldCell.swift
//  Alamofire
//
//  Created by 于冬冬 on 2023/6/13.
//


protocol FoldCellDelegate: AnyObject {
    func foldCellDidTapRightArea(_ cell: FoldCell)
    func foldCellDidTapleftArea(_ cell: FoldCell)
}


final class FoldCell: UICollectionViewCell {
    
    weak var delegate: FoldCellDelegate?
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .cs_softWhite
        label.font = .boldBody
        label.isUserInteractionEnabled = true
        return label
    }()
    
    let arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.bundleImage(named: "friend_section_more")
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    let rightLabel: UILabel = {
        let label = UILabel()
        label.textColor = .cs_decoLightPurple
        label.font = .regularSubheadline
        label.isUserInteractionEnabled = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        let leftActionView = UIView()
        leftActionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(sectionLeftClick)))
        titleLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(sectionLeftClick)))
        arrowImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(sectionLeftClick)))
        rightLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(sectionRightClick)))
        
        contentView.addSubview(leftActionView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(arrowImageView)
        contentView.addSubview(rightLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(18)
            make.centerY.equalToSuperview()
        }
        
        arrowImageView.snp.makeConstraints { make in
            make.left.equalTo(titleLabel.snp.right).offset(7)
            make.centerY.equalToSuperview()
        }
        
        leftActionView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(18)
            make.right.greaterThanOrEqualTo(arrowImageView.snp.right)
            make.width.greaterThanOrEqualTo(60)
        }
        
        rightLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(-18)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func sectionLeftClick() {
        delegate?.foldCellDidTapleftArea(self)
    }
    
    @objc private func sectionRightClick() {
        delegate?.foldCellDidTapRightArea(self)
    }
    
}
