//
//  LineSheetPresentationController.swift
//  CSFieldModule
//
//  Created by 于冬冬 on 2023/4/10.
//

class LineSheetPresentationController: UIPresentationController {
    
//    let effectView: UIVisualEffectView
    let effectView = UIView()
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        let screenSize = UIScreen.main.bounds.size
//        effectView = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialDark))
//        effectView.isUserInteractionEnabled = true
//        effectView.frame = CGRect(origin: .zero, size: screenSize)
//        effectView.backgroundColor = .clear
//        effectView.alpha = 0
        effectView.frame = CGRect(origin: .zero, size: screenSize)
        effectView.backgroundColor = UIColor(hex: 0x10101e, alpha: 0.4)
        effectView.alpha = 0
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        containerView?.addSubview(effectView)
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.effectView.alpha = 1
        })
    }
    
    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.effectView.alpha = 0
        })
    }
}
