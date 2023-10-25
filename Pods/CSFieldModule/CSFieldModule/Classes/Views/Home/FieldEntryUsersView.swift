//
//  FieldEntryUsersView.swift
//  CSFieldModule
//
//  Created by 于冬冬 on 2023/5/17.
//

import Foundation
import CSUtilities

class FieldEntryUsersView: UIView {
    
    var usersClickCallback: Action?
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 26, height: 26)
        layout.minimumLineSpacing = -6
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.register(FieldEntryUserAvatarView.self, forCellWithReuseIdentifier: FieldEntryUserAvatarView.cellIdentifier)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension FieldEntryUsersView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FieldEntryUserAvatarView.cellIdentifier, for: indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        usersClickCallback?()
    }
    
    
}
