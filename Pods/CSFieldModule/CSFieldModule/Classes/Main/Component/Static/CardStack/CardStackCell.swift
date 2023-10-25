//
//  CardStackCell.swift
//  comesocial
//
//  Created by 于冬冬 on 2022/11/23.
//

import UIKit
import CSImageKit

class CardStackCell: UICollectionViewCell {
    static let identifer = "CardStackCell"

    
    override func prepareForReuse() {
        super.prepareForReuse()
        isHidden = false
    }
    
    let cardImageView = UIImageView()
//    let namelabel: UILabel = {
//        let label = UILabel()
//        label.numberOfLines = 0
//        label.font = UIFont.name(.avenirNextRegular, size: 12)
//        label.textAlignment = .center
//        return label
//    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        layerCornerRadius = 6
        clipsToBounds = true
        
        contentView.backgroundColor = .white
        contentView.addSubview(cardImageView)
        cardImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
//        addSubview(namelabel)
//        namelabel.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
    }

    func updateCard(_ card: CardModel) {
        cardImageView.setCard(with: card.image)
//        namelabel.text = card.displayName
    }
    
    func updateDisplay(_ show: Bool) {
        isHidden = !show
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        let att = layoutAttributes as! CardStackCollectionViewLayoutAttributes
        if att.fold {
            layer.anchorPoint = CGPoint(x: 0.5, y: 1)
            layer.position.y = layer.position.y + (layer.anchorPoint.y - 0.5) * bounds.height * 0.8
        } else {
            layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        }
        contentView.isHidden = att.contentHidden

    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
