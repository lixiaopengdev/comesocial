//
//  BottomToTopTransition.swift
//  Alamofire
//
//  Created by 于冬冬 on 2023/5/9.
//

import Foundation

class BottomToTopTransition: NSObject {
    
    let height: CGFloat
    
    init(height: CGFloat) {
        self.height = height
    }
    
    private weak var toView: UIView?

    private var presentingVC: UIViewController?
    private var presentedVC: UIViewController?

}

extension BottomToTopTransition: UIViewControllerTransitioningDelegate {
    
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

extension BottomToTopTransition: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.35
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let fromVC = transitionContext.viewController(forKey: .from)
        let toVC = transitionContext.viewController(forKey: .to)
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
        toView.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height:height)
        
        let tapView = UIView()
        tapView.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height - height)
        tapView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissVC)))
        
       
        
        
        containerView.addSubview(tapView)
        
        containerView.addSubview(toView)
        self.toView = toView
        
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: duration) {
            toView.frame.origin.y = screenSize.height - self.height
        } completion: { complete in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    func dismissedAnimate(using transitionContext: UIViewControllerContextTransitioning) {
        
        let duration = transitionDuration(using: transitionContext)
        let screenSize = UIScreen.main.bounds.size

        UIView.animate(withDuration: duration) {
            self.toView?.frame.origin.y = screenSize.height
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
