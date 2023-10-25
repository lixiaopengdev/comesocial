//
//  CenterInTransition.swift
//  CSUtilities
//
//  Created by 于冬冬 on 2023/5/10.
//

import Foundation

class CenterInTransition: NSObject {

    
    private weak var toView: UIView?
    private weak var effectView: UIView?

    private var presentingVC: UIViewController?
    private var presentedVC: UIViewController?

}

extension CenterInTransition: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        presentingVC = presenting
        presentedVC = presented
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }

    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return nil
    }
    
}

extension CenterInTransition: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let fromVC = transitionContext.viewController(forKey: .from)
//        let toVC = transitionContext.viewController(forKey: .to)
        let isPresented = presentingVC === fromVC
        if isPresented {
            presentedAnimate(using: transitionContext)
        } else {
            dismissedAnimate(using: transitionContext)
        }
        
    }
    
    func presentedAnimate(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let toView = transitionContext.view(forKey: .to) else { return }
        let containerView = transitionContext.containerView
        let screenSize = UIScreen.main.bounds.size
        
        toView.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
        
        let tapView = UIView()
        tapView.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
        tapView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissVC)))
        
        toView.insertSubview(tapView, at: 0)
        
        let effectView = UIView()
        effectView.isUserInteractionEnabled = true
        effectView.frame = CGRect(origin: .zero, size: screenSize)
        effectView.backgroundColor = UIColor(hex: 0x10101e, alpha: 0.4)
        effectView.alpha = 0
        self.effectView = effectView
        
        containerView.addSubview(effectView)
        containerView.addSubview(toView)
        self.toView = toView
        
        let duration = transitionDuration(using: transitionContext)
       
        toView.alpha = 0
        UIView.animate(withDuration: duration) {
            effectView.alpha = 1
            toView.alpha = 1
        } completion: { complete in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    func dismissedAnimate(using transitionContext: UIViewControllerContextTransitioning) {
        
        let duration = transitionDuration(using: transitionContext)
//        _ = UIScreen.main.bounds.size

        UIView.animate(withDuration: duration) {
            self.toView?.alpha = 0
            self.effectView?.alpha = 0
        } completion: { complete in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            if !transitionContext.transitionWasCancelled {
                self.clearContext()
            }
        }

    }
    
    func clearContext() {
        presentingVC = nil
        presentedVC = nil
    }
    
    @objc func dismissVC() {
        presentingVC?.dismiss(animated: true)
    }

}
