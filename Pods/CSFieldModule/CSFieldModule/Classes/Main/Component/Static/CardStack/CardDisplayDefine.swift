//
//  CardDisplayDefine.swift
//  comesocial
//
//  Created by 于冬冬 on 2022/12/1.
//

import UIKit
import CSUtilities

//class CardDisplayView {}

protocol CardDisplay {
    var cardAppearStyle: CardDisplayView.CardStyle { get }
    var cardAppearAnimationStyle: CardDisplayView.AnimationStyle  { get }
    var image: String? { get }
    var backImage: String? { get }
    var applyType:CardDisplayView.CardDismissType { get }
    var applyTitle:String { get }
}

extension CardDisplayView {
    
    enum CardStyle {
        case small
        case large
    }
    
    enum AnimationStyle {
        case move
        case rotateAndMove
    }
    
    enum CardDismissType {
        case none
        case apply
        case send
    }
}

extension CardDisplayView.CardStyle {
    var margin: CGFloat {
        switch self {
        case .large:
            return 36
        case .small:
            return 72
        }
    }
    
    var size: CGSize {
        let width = Device.UI.screenWidth - margin * 2
        return CGSize(width: width, height: width * 7 / 5)
    }
}

extension CardModel: CardDisplay {
    var applyTitle: String {
        switch cardType {
        case .nftBuild:
            return "Mint"
        case .airDrop, .discord:
            return "Send"
        default:
            return "Applay"
        }
    }
    
   private static var catchedNFT = false
    var image: String? {
        return coverURL

//        return backCoverURL
    }
    
    var backImage: String? {
        return nil
//        return coverURL

    }
    
    var applyType: CardDisplayView.CardDismissType {
        switch cardType {
        case .nftBuild, .airDrop, .discord:
            return .send
        default:
            return .apply
        }
    }
    
    var cardAppearStyle: CardDisplayView.CardStyle {
        if type == .nftBuild {
            return . large
        }
        return .small
    }
    
    var cardAppearAnimationStyle: CardDisplayView.AnimationStyle {
        if image != nil && backImage != nil {
            return .rotateAndMove
        }
        return .move

    }
}
