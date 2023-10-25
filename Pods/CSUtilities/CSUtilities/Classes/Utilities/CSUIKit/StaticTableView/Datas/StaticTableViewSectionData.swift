//
//  StaticTableViewSection.swift
//  CSUtilities
//
//  Created by 于冬冬 on 2023/5/8.
//

import Foundation

public class StaticTableViewSectionData {
    let header: String?
    let cells: [StaticTableViewCellData]
    
    var titleHeight: CGFloat {
        return header == nil ? 0.001 : 44
    }
    var count: Int {
        return cells.count
    }
    
    
    public init(header: String?, cells: [StaticTableViewCellData]) {
        self.header = header
        self.cells = cells
    }
    
    subscript(index: Int) -> StaticTableViewCellData {
        return cells[index]
    }

}
