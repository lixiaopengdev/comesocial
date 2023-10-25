//
//  StaticEditTextCellData.swift
//  CSUtilities
//
//  Created by 于冬冬 on 2023/5/9.
//

import Foundation

public class StaticEditTextCellData: StaticTableViewCellData {
        
    
    var title: String
    var content: String?
    
    public var cellContent: String? {
        return (cell as? StaticEditTextCell)?.textView.text
    }
    public var cellClickCallback: ClickCallback?
    public var endEditCallback: ClickCallback?

    lazy public var cell: UITableViewCell = {
        let cell = StaticEditTextCell(data: self)
        return cell
    }()
    
    public init(title: String, content: String?, callback: ClickCallback? = nil) {
        self.title = title
        self.content = content
        self.cellClickCallback = callback
    }
    
    public convenience init(title: String) {
        self.init(title: title, content: nil)
    }
    
    public func update(content: String?) {
        self.content = content
        (cell as? StaticEditTextCell)?.update()
    }
    
    public func update(callback: ClickCallback?) {
        self.cellClickCallback = callback
    }
    public func updateEndEdit(callback: ClickCallback?) {
        self.endEditCallback = callback
    }
}
