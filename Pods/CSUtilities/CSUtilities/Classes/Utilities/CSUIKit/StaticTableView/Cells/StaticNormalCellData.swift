//
//  StaticTableViewNormalCellData.swift
//  CSUtilities
//
//  Created by 于冬冬 on 2023/5/8.
//

import Foundation

public class StaticNormalCellData: StaticTableViewCellData {
        
    
    var title: String
    var subtitle: String?
    var right: StaticTableViewRightStyle
    public var cellClickCallback: ClickCallback?
    
    lazy public var cell: UITableViewCell = {
        let cell = StaticNormalCell(data: self)
        return cell
    }()
    
    public init(title: String, subtitle: String?, right: StaticTableViewRightStyle, callback: ClickCallback? = nil) {
        self.title = title
        self.subtitle = subtitle
        self.right = right
        self.cellClickCallback = callback
    }
    
    public convenience init(title: String, right: StaticTableViewRightStyle, callback: ClickCallback? = nil) {
        self.init(title: title, subtitle: nil, right: right, callback: callback)
    }
    
    public convenience init(title: String) {
        self.init(title: title, subtitle: nil, right: .text(""), callback: nil)
    }
    
    public func update(subtitle: String? = nil, right: StaticTableViewRightStyle = .text(""), callback: ClickCallback? = nil) {
        self.subtitle = subtitle
        self.right = right
        self.cellClickCallback = callback
        (cell as? StaticNormalCell)?.update()
    }
    
    public func update(right: StaticTableViewRightStyle = .text(""), callback: ClickCallback? = nil) {
        self.right = right
        self.cellClickCallback = callback
        (cell as? StaticNormalCell)?.update()
    }
    
    public func update(callback: ClickCallback?) {
        self.cellClickCallback = callback
    }
    
    public func update(subtitle: String?) {
        self.subtitle = subtitle
        (cell as? StaticNormalCell)?.update()
    }
    
    public func update(right: StaticTableViewRightStyle) {
        self.right = right
        (cell as? StaticNormalCell)?.update()
    }
    
    deinit {
        print("StaticNormalCellData deinit")
    }

}
