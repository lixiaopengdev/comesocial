//
//  CardNormalView.swift
//  comesocial
//
//  Created by 于冬冬 on 2022/12/22.
//

import UIKit


class CardNormalView: CardContentView {
    private lazy var cardImageView: UIImageView = {
       let imageView = UIImageView()
//        imageView.backgroundColor = .white
        if cardContext.card.cardAppearAnimationStyle == .move {
            imageView.setCard(with: cardContext.card.image)
        } else {
            imageView.setCard(with: cardContext.card.backImage)
        }
        return imageView
    }()
    
    let namelabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    let cardContext: CardContext
    
    init(cardContext: CardContext) {
        self.cardContext = cardContext
        super.init(frame: .zero)
        addSubview(cardImageView)
        cardImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        addSubview(namelabel)
        namelabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
//        namelabel.text = cardContext.card.description
    }
    
    override func willApply() -> CardContext {
        return cardContext
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        cardImageView.layerCornerRadius = cardImageView.frame.width * 0.1
    }
}
