//
//  FieldUserHeaderView.swift
//  CSFieldModule
//
//  Created by 于冬冬 on 2023/5/19.
//

import Foundation
import CSCommon
import CSUtilities

class FieldUserHeaderView: UIView {
    
    var cards: [String] = []
    
    let avatarContainer: UIView = {
        let view = UIView()
        return view
    }()
    
    let avatarImageView: CSCommon.AvatarView = {
        let imageView = CSCommon.AvatarView()
        return imageView
    }()
    
    lazy var inviteBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = .boldSubheadline
        button.setTitle("Invite", for: .normal)
        button.setTitle("Inviting...", for: .disabled)
        button.setTitleColor(.cs_pureWhite, for: .normal)
        button.setBackgroundColor(color: .cs_cardColorB_40, forState: .normal)
        button.setTitleColor(.cs_lightGrey, for: .disabled)
        button.setBackgroundColor(color: .cs_cardColorA_40, forState: .disabled)
        button.addTarget(self, action: #selector(inviteUser), for: .touchUpInside)
        button.layerCornerRadius = 18
        return button
    }()
    let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .cs_decoDarkPurple
        return view
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .cs_softWhite
        label.font = .regularTitle1
        label.text = "Rose Westwood’s Field"
        label.textAlignment = .center
        return label
    }()
    
    lazy var previewBtn: CSGradientButton = {
        let button = CSGradientButton()
        button.setTitle("Preview", for: .normal)
        button.titleLabel?.font = .boldSubheadline
        button.layerCornerRadius = 18
        button.addTarget(self, action: #selector(previewField), for: .touchUpInside)
        return button
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 42, height: 56)
        layout.minimumLineSpacing = 8
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.register(CardCollectionCell.self, forCellWithReuseIdentifier: CardCollectionCell.cellIdentifier)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    var headerHeight: CGFloat {
        let topH: CGFloat = cards.isEmpty ? 18 + 86 + 16 : 32 + 54 + 20
        return topH + 36 + 24 + 24 + 25 + 12 + 36 + 8
    }
    
    
    init(_ cards: [String]) {
        super.init(frame: .zero)
        self.cards = cards
        addSubview(avatarContainer)
        avatarContainer.addSubview(avatarImageView)
        addSubview(inviteBtn)
        addSubview(lineView)
        addSubview(nameLabel)
        addSubview(previewBtn)
        
        if cards.isEmpty {
            avatarContainer.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalTo(18)
            }
            avatarImageView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
                make.size.equalTo(86)
            }
            inviteBtn.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalTo(avatarContainer.snp.bottom).offset(20)
                make.size.equalTo(CGSize(width: 96, height: 36))
            }
        } else {
            avatarContainer.addSubview(collectionView)
            
            avatarContainer.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalTo(32)
            }
            avatarImageView.snp.makeConstraints { make in
                make.size.equalTo(54)
                make.left.equalToSuperview()
                make.centerY.equalToSuperview()
            }
            
            let width = min(Device.UI.screenWidth - 40 - 54, 50 * CGFloat(cards.count))
            collectionView.snp.makeConstraints { make in
                make.left.equalTo(avatarImageView.snp.right).offset(8)
                make.top.bottom.right.equalToSuperview()
                make.height.equalTo(56)
                make.width.equalTo(width)
            }
            inviteBtn.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalTo(avatarContainer.snp.bottom).offset(16)
                make.size.equalTo(CGSize(width: 96, height: 36))
            }
            
            collectionView.reloadData()
        }
 

        lineView.snp.makeConstraints { make in
            make.left.equalTo(18)
            make.right.equalTo(-18)
            make.height.equalTo(0.5)
            make.top.equalTo(inviteBtn.snp.bottom).offset(24)
        }
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(18)
            make.right.equalTo(-18)
            make.top.equalTo(lineView.snp.bottom).offset(24)
        }
        previewBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(nameLabel.snp.bottom).offset(12)
            make.size.equalTo(CGSize(width: 89, height: 36))
        }
        avatarImageView.updateAvatar("https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fsafe-img.xhscdn.com%2Fbw1%2F4d2a8885-131d-4530-835a-0ee12ae4201b%3FimageView2%2F2%2Fw%2F1080%2Fformat%2Fjpg&refer=http%3A%2F%2Fsafe-img.xhscdn.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1683105048&t=858875bf4e253fe95ef0534174afd65e")

    }
    

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func previewField() {
        
    }
    
    @objc func inviteUser() {
        
    }
}


extension FieldUserHeaderView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCollectionCell.cellIdentifier, for: indexPath)
            (cell as? CardCollectionCell)?.update(cards[indexPath.row])
        return cell
    }
    
}


extension FieldUserHeaderView {
    class CardCollectionCell: UICollectionViewCell {
        let cardImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.backgroundColor = .cs_softWhite
            imageView.layerCornerRadius = 5
            return imageView
        }()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            backgroundColor = .clear
            
            contentView.addSubview(cardImageView)
            cardImageView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
        
        func update(_ card: String) {
            cardImageView.setCard(with: card)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    
}
