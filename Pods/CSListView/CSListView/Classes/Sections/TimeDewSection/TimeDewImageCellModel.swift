//
//  TimeDewImageCellModel.swift
//  CSListView
//
//  Created by fuhao on 2023/6/19.
//

import Foundation
import IGListSwiftKit
import IGListKit


final class TimeDewImageCellModel: TimeDewBaseCellModel, ListDiffable {
    let ImageURL: String


    init(ImageURL: String?) {
        self.ImageURL = ImageURL ?? ""
    }

    func diffIdentifier() -> NSObjectProtocol {
        return "ImageContentCellModel" as NSObjectProtocol
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? TimeDewImageCellModel else  { return false }
        return ImageURL == object.ImageURL && isBottom == object.isBottom
    }
}
