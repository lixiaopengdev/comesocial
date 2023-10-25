//
//  TimeDewTextContentCellModel.swift
//  CSListView
//
//  Created by fuhao on 2023/6/19.
//

import Foundation
import IGListSwiftKit
import IGListKit


final class TimeDewTextContentCellModel: TimeDewBaseCellModel, ListDiffable {
    let content: String

    init(content: String?) {
        self.content = content ?? ""
    }

    func diffIdentifier() -> NSObjectProtocol {
        return "TextContentCellModel" as NSObjectProtocol
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? TimeDewTextContentCellModel else  { return false }
        return content == object.content && isBottom == object.isBottom
    }
}
