//
//  StaticTableViewCell.swift
//  CSUtilities
//
//  Created by 于冬冬 on 2023/5/8.
//

public protocol StaticTableViewCellData {
    
    typealias ClickCallback = (StaticTableViewCellData) -> Void

    var cell: UITableViewCell { get }
//    var identifier: String { get }
    var cellClickCallback: ClickCallback? { get }

}
