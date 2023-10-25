//
//  TimeDewTitleCellModel.swift
//  CSListView
//
//  Created by fuhao on 2023/6/19.
//

import Foundation
import IGListSwiftKit
import IGListKit

public enum TitleType {
    case normal
    case personal
}


class TimeDewTitleCellModel: TimeDewBaseCellModel, ListDiffable {
    let icon: String
    let title: String
    let timeStamp: String
    var type: TitleType

    init(icon: String, title: String, timeStamp: String, type: TitleType = .normal) {
        self.icon = icon
        self.title = title
        self.timeStamp = timeStamp
        self.type = type
    }

    func diffIdentifier() -> NSObjectProtocol {
        return "TitleCellModel" as NSObjectProtocol
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? TimeDewTitleCellModel else  { return false }
        return icon == object.icon
        && title == object.title
    }
}
