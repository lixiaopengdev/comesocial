//
//  FriendSearchCell.swift
//  CSFriendsModule
//
//  Created by 于冬冬 on 2023/6/14.
//

import CSUtilities

final class SearchCell: UICollectionViewCell {
    
    lazy var searchBar = CSSearchBar()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        contentView.addSubview(searchBar)
        searchBar.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
