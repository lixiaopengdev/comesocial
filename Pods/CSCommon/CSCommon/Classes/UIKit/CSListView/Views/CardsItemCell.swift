////
////  CardsItemCell.swift
////  CSCommon
////
////  Created by 于冬冬 on 2023/5/18.
////
//
//
//import UIKit
//import SnapKit
//import CSImageKit
//import CSUtilities
//
//class CardsItemCell: UITableViewCell {
//    
//    var item: CardsItemDisplay?
//    var indexPath: IndexPath = IndexPath(row: 0, section: 0)
//    
//    lazy var collectionView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        layout.itemSize = CGSize(width: 60, height: 80)
//        layout.minimumLineSpacing = 8
//        layout.scrollDirection = .horizontal
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        collectionView.delegate = self
//        collectionView.dataSource = self
//        collectionView.backgroundColor = .clear
//        collectionView.register(CardCollectionCell.self, forCellWithReuseIdentifier: CardCollectionCell.cellIdentifier)
//        collectionView.showsHorizontalScrollIndicator = false
//        return collectionView
//    }()
//    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        
//        backgroundColor = .clear
//        selectionStyle = .none
//        
//        contentView.addSubview(collectionView)
//        collectionView.snp.makeConstraints { make in
//            make.edges.equalTo(UIEdgeInsets(top: 8, left: 18, bottom: 8, right: 18))
//        }
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    func update(_ item: CardsItemDisplay) {
//        self.item = item
//        collectionView.reloadData()
//    }
//    
//}
//
//extension CardsItemCell: UICollectionViewDelegate, UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return item?.cards.count ?? 0
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCollectionCell.cellIdentifier, for: indexPath)
//        if let card = item?.cards[indexPath.row] {
//            (cell as? CardCollectionCell)?.update(card)
//        }
//        return cell
//    }
//    
//}
//
//
//extension CardsItemCell {
//    class CardCollectionCell: UICollectionViewCell {
//        let cardImageView: UIImageView = {
//            let imageView = UIImageView()
//            imageView.backgroundColor = .cs_softWhite
//            imageView.layerCornerRadius = 5
//            return imageView
//        }()
//        
//        override init(frame: CGRect) {
//            super.init(frame: frame)
//            backgroundColor = .clear
//            
//            contentView.addSubview(cardImageView)
//            cardImageView.snp.makeConstraints { make in
//                make.edges.equalToSuperview()
//            }
//        }
//        
//        func update(_ card: CardDisplay) {
//            cardImageView.setCard(with: card.icon)
//        }
//        
//        required init?(coder: NSCoder) {
//            fatalError("init(coder:) has not been implemented")
//        }
//    }
//    
//    
//}
