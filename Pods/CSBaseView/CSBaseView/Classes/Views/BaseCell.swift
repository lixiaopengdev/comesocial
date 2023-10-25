//
//  BaseCell.swift
//  Alamofire
//
//  Created by 于冬冬 on 2023/2/6.
//

import UIKit

public protocol ConvenientIdentifier {}

public extension ConvenientIdentifier {
    
    static var cellIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ConvenientIdentifier {}

extension UITableViewHeaderFooterView: ConvenientIdentifier {}

extension UICollectionReusableView: ConvenientIdentifier {}
