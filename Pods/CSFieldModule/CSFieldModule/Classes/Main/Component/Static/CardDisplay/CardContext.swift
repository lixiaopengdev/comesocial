//
//  CardContext.swift
//  comesocial
//
//  Created by 于冬冬 on 2022/12/22.
//

import UIKit

class CardContext {
    let card: CardModel
    
    var canApply: Bool {
        return true
    }
    
    var isNFTBuilder: Bool{
        return card.cardType == .nftBuild
    }
    
    var id: String {
        String(card.id ?? 0)
    }
    
    var tips: String {
        return ""
    }
    
    fileprivate init(card: CardModel) {
        self.card = card
    }
    

    
}

class CardNFTContext: CardContext {
    var image: UIImage?
    var title: String = ""
    var subTitle: String = ""
    var time: String = ""
    override var canApply: Bool {
        return image != nil
    }
    
    override var tips: String {
        return "please select a photo"
    }
}


extension CardContext {
    
    static func initContext(cardModel: CardModel) -> CardContext {
        switch cardModel.cardType {
        case .nftBuild:
            return CardNFTContext(card: cardModel)
        default:
            return CardContext(card: cardModel)
        }
    }
}
