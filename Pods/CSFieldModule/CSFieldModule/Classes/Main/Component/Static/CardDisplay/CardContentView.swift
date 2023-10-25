//
//  CardContentView.swift
//  comesocial
//
//  Created by 于冬冬 on 2022/12/9.
//

import UIKit

class CardContentView: UIView {
    
    func willApply() -> CardContext {
        fatalError("sub class need implement")
    }
}

extension CardContentView {
    static func initCardContentView(cardContext: CardContext) -> CardContentView{
        if let context = cardContext as? CardNFTContext {
            return CardNFTView(cardContext: context)
        } else {
            return CardNormalView(cardContext: cardContext)
        }
    }
}
