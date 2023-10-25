//
//  CardApplyView.swift
//  comesocial
//
//  Created by 于冬冬 on 2022/11/30.
//

import UIKit
import CSUtilities

//import PKHUD
//import ComeSocialNetwork

//protocol CardDisplayViewDelegate: NSObjectProtocol {
//    func cardWillDismissDestinationFrame(_ displayView: CardDisplayView, type: CardDisplayView.CardDismissType) -> CGRect?
//    func cardDisplayViewDismiss(_ displayView: CardDisplayView, type: CardDisplayView.CardDismissType)
//
//}

class CardDisplayView: UIView {
    
    private let editBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage.bundleImage(named: "card_display_edit"), for: .normal)
        button.isHidden = true
        return button
    }()
    
    private let applayBtn: UIButton = {
        let button = UIButton(type: .custom)
//        button.setTitleColor(.white, for: .normal)
//        button.titleLabel?.font = .name(.avenirNextDemiBold, size: 17)
//        button.backgroundColor = .red
//        button.layerCornerRadius = 17
        button.setImage(UIImage.bundleImage(named: "field_inside_apply"), for: .normal)
        
        return button
    }()
    
    private let effectView: UIVisualEffectView = UIVisualEffectView()
    private let otherContainer: UIView = UIView()
    private let cardAnimationView = DoubleSideView()
    private let animationContainer = UIView()
    private var dismissing = false
    
    var coverLayer: CoverLayer {
        return assembly.resolve()
    }
    
    var cardContext: CardContext
    private let cardContentView: CardContentView
    private let assembly: FieldAssembly

//    weak var delegate: CardDisplayViewDelegate?
    
    init(card: CardModel, assembly: FieldAssembly) {
        self.assembly = assembly
        cardContext = CardContext.initContext(cardModel: card)
        cardContentView = CardContentView.initCardContentView(cardContext: cardContext)
        
        super.init(frame: CGRect(x: 0, y: 0, width: Device.UI.screenWidth, height: Device.UI.screenHeight))
//        cardContentView.observeContextChange {[weak self] newContext in
//            self?.cardContext = newContext
//        }
//        applayBtn.setTitle(cardContext.card.applyTitle, for: .normal)
        let dismissTap = UITapGestureRecognizer(target: self, action: #selector(tapOtherContainer))
        otherContainer.addGestureRecognizer(dismissTap)
        
        cardContentView.isUserInteractionEnabled = true
        
        applayBtn.addTarget(self, action: #selector(applyCard), for: .touchUpInside)
        editBtn.addTarget(self, action: #selector(editCard), for: .touchUpInside)
        
        configViews()
    }
    

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc private func applyCard() {
        
        let newcontext = cardContentView.willApply()
        cardContext = newcontext
        if !cardContext.canApply {
//            HUD.flash(.labeledError(title: nil, subtitle: cardContext.tips), delay: 3)
            return
        }
        if cardContext.isNFTBuilder, let newNFTView = cardContentView.screenshot {
            cardAnimationView.changeBackImage(newNFTView)
        }
        
        let type = cardContext.card.applyType
        let toFrame = cardWillDismissDestinationFrame(self, type: type) ?? CGRect(x: frame.midX, y: 0, width: 50, height: 70)
        dismiss(to: toFrame, apply: type) {
            self.cardDisplayViewDismiss(self, type: type)
        }
    }
    
    var cardStack: CardStackView {
        assembly.resolve()
    }
    
    func cardWillDismissDestinationFrame(_ displayView: CardDisplayView, type: CardDisplayView.CardDismissType) -> CGRect? {
        switch type {
        case .none:
            var fromFrame = CGRect.zero
            if let cell = cardStack.selectedCell {
                fromFrame = cell.convert(cell.bounds, to: displayView)
            }
            return fromFrame
        case .apply:
            return CGRect(x: coverLayer.frame.width / 2 - 25, y: -70, width: 50, height: 70)
//            return applyingCardView.convert(applyingCardView.cardImageView.frame, to: displayView)
        case .send:
            return CGRect(x: coverLayer.frame.width / 2 - 25, y: -70, width: 50, height: 70)
        }
    }
    
    func cardDisplayViewDismiss(_ displayView: CardDisplayView, type: CardDisplayView.CardDismissType) {
        
        var popCard: CardModel?
        
        if type == .apply {
//            popCard = applyingCardView.appendCard(displayView.cardContext.card)
//            assembly.fieldManager().useCard(card: displayView.cardContext.card)
            assembly.cardManager().useCard(displayView.cardContext.card)
        }
        if type != .none {
//            useCard(cardContext: displayView.cardContext)
        }
        cardStack.updateCellDisplay(type: type, cardModel: displayView.cardContext.card)
        if let popCard = popCard {
            cardStack.appendCard(cardModel: popCard)
        }
    }
    
    
    @objc private func editCard() {
        let setting = CardSettingView(frame: .zero, setting: [])
        self.superview?.addSubview(setting)
        setting.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func configViews() {
        addSubview(effectView)
        addSubview(otherContainer)
        
        addSubview(cardContentView)
        addSubview(editBtn)
        addSubview(applayBtn)
        
        addSubview(animationContainer)
        animationContainer.isUserInteractionEnabled = false
        animationContainer.addSubview(cardAnimationView)
        
        cardAnimationView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        effectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        animationContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        otherContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        cardContentView.snp.makeConstraints { make in
            make.centerY.equalTo(self.snp.centerY).offset(-10)
            make.centerX.equalTo(self.snp.centerX)
            make.size.equalTo(cardContext.card.cardAppearStyle.size)
        }
        
        editBtn.snp.makeConstraints { make in
            make.right.equalTo(cardContentView.snp.right).offset(-13)
            make.bottom.equalTo(cardContentView.snp.top).offset(-9)
            make.width.equalTo(CGSize(width: 24, height: 24))
        }
        
        applayBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(cardContentView.snp.bottom).offset(30)
            make.size.equalTo(CGSize(width: 200, height: 48))
        }
        
    }
    
    @objc private func tapOtherContainer() {
//        logger.debug(tapOtherContainer)
        let toFrame = cardWillDismissDestinationFrame(self, type: .none) ?? CGRect(x: frame.midX, y: 0, width: 50, height: 70)
        dismiss(to: toFrame, apply: .none) {
            self.cardDisplayViewDismiss(self, type: .none)
        }

    }

    
    func dismiss(to toFrame: CGRect, apply type: CardDismissType, completion: (() -> Void)? = nil) {
        if dismissing {
            cardAnimationView.stopDismissAnimation()
            return
        } else {
            cardAnimationView.stopShowAnimation()
        }
        dismissing = true
        let rotate = cardContext.card.cardAppearAnimationStyle == .rotateAndMove
        cardAnimationView.updateFrame(frame: cardContentView.frame, rotate: rotate)
        animationContainer.isHidden = false
        
        cardContentView.isHidden = true
        let rotateValue = (type == .none && rotate) ? -1 : 0
        cardAnimationView.animate(to: toFrame, show: false, rotate: rotateValue, withDuration: 0.5, dampingRatio: 1, initialSpringVelocity: 1) {
            self.effectView.effect = nil
            self.editBtn.alpha = 0
            self.applayBtn.alpha = 0
        } completion: { _ in
            completion?()
            self.removeFromSuperview()
        }
    }
    
    func show(from fromFrame: CGRect) {
//        if viewController != nil { return }
//        viewController = vc
//        fromCellFrame = fromFrame
        coverLayer.addSubview(self)
        snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        cardContentView.isHidden = true
        editBtn.alpha = 0
        applayBtn.alpha = 0
        layoutIfNeeded()
        cardAnimationView.updateFrame(frame: fromFrame)
        beginAppearAnimate()
    }

    // MARK:  Appear Animation
    private func beginAppearAnimate() {
        switch cardContext.card.cardAppearAnimationStyle {
        case .move:
            moveAppearAnimate()
        case .rotateAndMove:
            rotateAppearAnimate()
        }
    }
    
    private func moveAppearAnimate() {
        cardAnimationView.frontImage = cardContext.card.image
        appearAnimate(roate: false)

    }

    private func rotateAppearAnimate() {
        cardAnimationView.frontImage = cardContext.card.image
        cardAnimationView.backImage = cardContext.card.backImage
        appearAnimate(roate: true)
    }
    
    private func appearAnimate(roate: Bool) {
        cardAnimationView.animate(to: self.cardContentView.frame, show: true, rotate: roate ? 1 : 0, withDuration: 0.5, dampingRatio: 1, initialSpringVelocity: 1) {
            self.effectView.effect = UIBlurEffect(style: .dark)
            self.editBtn.alpha = 1
            self.applayBtn.alpha = 1

        } completion: { _ in
            self.animationContainer.isHidden = true
            self.cardContentView.isHidden = false
        }
    }
}

