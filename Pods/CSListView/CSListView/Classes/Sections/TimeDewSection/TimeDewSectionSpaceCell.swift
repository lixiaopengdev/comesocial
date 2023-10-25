//
//  TimeDewSectionSpaceCell.swift
//  CSListView
//
//  Created by fuhao on 2023/6/20.
//

import Foundation
import IGListSwiftKit
import IGListKit

class TimeDewSectionSpaceCell : UICollectionViewCell, ListBindable{
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    func bindViewModel(_ viewModel: Any) {
        
    }
}
