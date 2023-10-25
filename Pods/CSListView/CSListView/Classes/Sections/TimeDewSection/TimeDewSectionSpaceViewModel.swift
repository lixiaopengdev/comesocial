//
//  TimeDewSectionSpaceViewModel.swift
//  CSListView
//
//  Created by fuhao on 2023/6/20.
//

import Foundation
import IGListSwiftKit
import IGListKit


class TimeDewSectionSpaceViewModel: ListDiffable {


    func diffIdentifier() -> NSObjectProtocol {
        return "TimeDewSectionSpaceViewModel" as NSObjectProtocol
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return true
    }
}
