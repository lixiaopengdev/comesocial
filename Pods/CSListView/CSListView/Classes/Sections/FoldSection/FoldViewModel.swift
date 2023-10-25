//
//  FoldCellsViewModel.swift
//  Alamofire
//
//  Created by 于冬冬 on 2023/6/13.
//

import IGListKit

final public class FoldViewModel {
    let leftTitle: String
    let rightAttributedTitle: NSAttributedString?
    public var fold: Bool?
    
    public init(leftTitle: String, rightTitle: String?, fold: Bool?) {
        self.leftTitle = leftTitle
        self.rightAttributedTitle = NSAttributedString(string: rightTitle ?? "").font(.regularSubheadline).foregroundColor(.cs_decoLightPurple)
        self.fold = fold
    }
    
    public init(leftTitle: String, rightAttributedTitle: NSAttributedString?, fold: Bool?) {
        self.leftTitle = leftTitle
        self.rightAttributedTitle = rightAttributedTitle
        self.fold = fold
    }
}

extension FoldViewModel: ListDiffable {
    
    public func diffIdentifier() -> NSObjectProtocol {
        return leftTitle as NSObjectProtocol
    }
    
    public func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if self === object { return true }
        guard let object = object as? FoldViewModel else { return false }
        return rightAttributedTitle == object.rightAttributedTitle && fold == object.fold
    }
}
