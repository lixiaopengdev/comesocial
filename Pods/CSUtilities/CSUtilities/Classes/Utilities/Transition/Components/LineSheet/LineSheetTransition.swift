//
//  TransitionModel.swift
//  Alamofire
//
//  Created by 于冬冬 on 2023/4/10.
//

import Foundation

class LineSheetTransition: NSObject {
    
    let height: CGFloat
    var timeInterval: TimeInterval
    
    init(height: CGFloat,timeInterval: TimeInterval) {
        self.height = height
        self.timeInterval = timeInterval
    }
    
    private var presentingVC: UIViewController?
    private var presentedVC: UIViewController?

    private var boxView: UIView?
    
    private var interactiveTransition: LineSheetInteractiveTransition? = LineSheetInteractiveTransition()
}

extension LineSheetTransition: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        presentingVC = presenting
        presentedVC = presented
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return (interactiveTransition?.isInProgress ?? false) ? interactiveTransition : nil
    }

    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return LineSheetPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
}

extension LineSheetTransition: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.timeInterval
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
        toView.frame = CGRect(x: 0, y: 40, width: screenSize.width, height:height)
        
        let tapView = UIView()
        tapView.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height - height - 40)
        tapView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissVC)))
        
        let boxView = UIImageView()
        boxView.backgroundColor = nil
        boxView.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: height + 40)
        
        
        if let bgImage = UIImage.bundleImage(named: "line_sheet_box") {
            let newBgImage = bgImage.resizableImage(withCapInsets: UIEdgeInsets(top: bgImage.size.height * 0.2, left: bgImage.size.width * 0.2, bottom: bgImage.size.height * 0.4, right: bgImage.size.width * 0.4), resizingMode: .stretch)
            boxView.image = newBgImage
        }
        
        
        boxView.isUserInteractionEnabled = true
        boxView.contentMode = .scaleToFill
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panAction(_:)))
        boxView.addGestureRecognizer(pan)
        
        
        containerView.addSubview(tapView)
        containerView.addSubview(boxView)
        
        boxView.addSubview(toView)

        
        self.boxView = boxView
        
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: duration) {
            boxView.frame.origin.y = screenSize.height - self.height - 40
        } completion: { complete in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    func dismissedAnimate(using transitionContext: UIViewControllerContextTransitioning) {
        
        let duration = transitionDuration(using: transitionContext)
        let screenSize = UIScreen.main.bounds.size

        UIView.animate(withDuration: duration) {
            self.boxView?.frame.origin.y = screenSize.height
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
        interactiveTransition = nil
    }
    
    @objc func dismissVC() {
        presentingVC?.dismiss(animated: true)
    }
    
    @objc func panAction(_ pan: UIPanGestureRecognizer) {
        guard let boxView  = boxView else { return }
        let offset = pan.translation(in: boxView)
        switch pan.state {
        case .began:
            interactiveTransition?.isInProgress = true
            dismissVC()
        case .changed:
            let progress = offset.y / height
            interactiveTransition?.update(progress)
        case .ended:
            let velocity = pan.velocity(in: boxView)
            print(velocity)
            let progress = (offset.y + velocity.y * 0.35)  / height
            if progress > 0.5 {
                interactiveTransition?.finish()
            } else {
                interactiveTransition?.cancel()
            }
            interactiveTransition?.isInProgress = false
        case .possible:
            break
        default:
            interactiveTransition?.cancel()
            interactiveTransition?.isInProgress = false
        }
    }
}



