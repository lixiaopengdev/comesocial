//
//  DoubleSideView.swift
//  comesocial
//
//  Created by 于冬冬 on 2022/11/30.
//

import UIKit
//import Kingfisher
import CSImageKit

class DoubleSideView: UIView, CAAnimationDelegate {
    
    private static let showAnimationKey = "show"
    private static let dismissAnimationKey = "dismiss"
    
    //    override class var layerClass: AnyClass { return CATransformLayer.self }
    
    private let transformLayer = CATransformLayer()
    private let backLayer = CALayer()
    private let frontLayer = CALayer()
    private var showCallback: ((Bool) -> Void)?
    private var dismissCallback: ((Bool) -> Void)?
    
    var frontImage: String? {
        didSet {
            ImageKit.shared.retrieveImage(with: frontImage) { [weak self] result in
                switch result {
                case .success(let imageResult):
                    self?.frontLayer.contents = imageResult.image.cgImage
                case .failure:
                    break
                }
            }
        }
    }
    
    var backImage: String? {
        didSet {
            ImageKit.shared.retrieveImage(with: backImage) { [weak self] result in
                switch result {
                case .success(let imageResult):
                    self?.backLayer.contents = imageResult.image.cgImage
                case .failure:
                    break
                }
            }
        }
    }
    
    func changeBackImage(_ image: UIImage) {
        backLayer.contents = image.cgImage
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backLayer.isDoubleSided = false
        frontLayer.isDoubleSided = false
        layer.addSublayer(transformLayer)
        transformLayer.addSublayer(backLayer)
        transformLayer.addSublayer(frontLayer)
        initDefaultCOntent()
    }
    
    func initDefaultCOntent() {
        DispatchQueue.global().async { [weak self] in
            let image =  UIImage(color: .white, size: CGSize(width: 500, height: 700)).withRoundedCorners(radius: 50)
            DispatchQueue.main.async {
                guard let self = self else { return }
                if self.frontLayer.contents == nil {
                    self.frontLayer.contents = image?.cgImage
                }
                if self.backLayer.contents == nil {
                    self.backLayer.contents = image?.cgImage
                }
            }
            
        }
    }
    
    func updateFrame(frame: CGRect, rotate: Bool = false) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        var ct =  CATransform3DMakeTranslation(0, 0, -1);
        ct = CATransform3DRotate(ct, CGFloat.pi, 0, 1, 0)
        if (rotate) {
            backLayer.transform = CATransform3DIdentity
            frontLayer.transform = ct
        } else {
            backLayer.transform = ct
            frontLayer.transform = CATransform3DIdentity
        }
        transformLayer.frame = frame
        transformLayer.transform = CATransform3DIdentity
        backLayer.frame = CGRect(origin: .zero, size: frame.size)
        frontLayer.frame = CGRect(origin: .zero, size: frame.size)
        CATransaction.commit()
    }
    
    func stopShowAnimation() {
        if transformLayer.animation(forKey: DoubleSideView.showAnimationKey) != nil {
            showCallback?(false)
            showCallback = nil
            transformLayer.removeAnimation(forKey: DoubleSideView.showAnimationKey)
        }
    }
    
    func stopDismissAnimation() {
        if transformLayer.animation(forKey: DoubleSideView.dismissAnimationKey) != nil {
            dismissCallback?(false)
            dismissCallback = nil
            transformLayer.removeAnimation(forKey: DoubleSideView.dismissAnimationKey)
        }
    }
    
    func animate(to toFrame: CGRect, show: Bool, rotate: Int, withDuration duration: TimeInterval, dampingRatio: CGFloat, initialSpringVelocity velocity: CGFloat, animations: @escaping () -> Void, completion: ((Bool) -> Void)? = nil) {
        if show {
            showCallback = completion
        } else {
            dismissCallback = completion
        }
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity, animations: animations)
        
        let posAni = CASpringAnimation(keyPath: "position")
        posAni.toValue = CGPoint(x: toFrame.midX, y: toFrame.midY)
        posAni.configSpring(initialVelocity: velocity, relaxationTime: duration, dampingRatio: dampingRatio)
        
        
        let transformAni = CASpringAnimation(keyPath: "transform")
        let scale = toFrame.width / transformLayer.frame.width
        var ct = CATransform3DMakeScale(scale, scale, 1)
        ct.m34 = -1 / 700
        if ( rotate != 0 ) {
            ct = CATransform3DRotate(ct, CGFloat.pi * CGFloat(rotate), 0, 1, 0)
        }
        transformAni.toValue = ct
        transformAni.configSpring(initialVelocity: velocity, relaxationTime: duration, dampingRatio: dampingRatio)
        
        let group = CAAnimationGroup()
        group.delegate = self
        group.isRemovedOnCompletion = false
        group.animations = [posAni, transformAni]
        group.duration = posAni.settlingDuration
        group.fillMode = .forwards
        group.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transformLayer.add(group, forKey: show ? DoubleSideView.showAnimationKey : DoubleSideView.dismissAnimationKey)
        
    }
    
    
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if transformLayer.animation(forKey: DoubleSideView.showAnimationKey) == anim {
            showCallback?(flag)
            showCallback = nil
            transformLayer.removeAnimation(forKey: DoubleSideView.showAnimationKey)
        }
        if transformLayer.animation(forKey: DoubleSideView.dismissAnimationKey) == anim {
            dismissCallback?(flag)
            dismissCallback = nil
            transformLayer.removeAnimation(forKey: DoubleSideView.dismissAnimationKey)
        }
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        if view == self {
            return nil
        }
        return view
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CASpringAnimation {
    func configSpring(initialVelocity: CGFloat, relaxationTime: CGFloat, dampingRatio: CGFloat) {
        let clippedDampingRatio: CGFloat = min(1, max(dampingRatio, 0.01))
        let mass: CGFloat = 1
        let fractionOfAmplitude: CGFloat = 1500 //A spring never gets to 0 amplitude, it gets infinitely smaller. This fraction represents the perceived 0 point.
        let logOfFraction: CGFloat = log(fractionOfAmplitude)
        let stiffness: CGFloat = (mass * pow(logOfFraction, 2)) / (pow(relaxationTime, 2) * pow(clippedDampingRatio, 2))
        let angularFrequency: CGFloat = sqrt(stiffness/mass)
        let damping: CGFloat = 2 * mass * angularFrequency * clippedDampingRatio

        self.initialVelocity = initialVelocity
        self.mass = mass
        self.stiffness = stiffness
        self.damping = damping
    }
}
