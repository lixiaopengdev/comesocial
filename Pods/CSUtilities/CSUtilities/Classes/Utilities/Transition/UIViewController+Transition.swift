//
//  UIViewController+Transition.swift
//  CSFieldModule
//
//  Created by 于冬冬 on 2023/4/10.
//

import Foundation

private var transitioningStoreContext: UInt8 = 0

public extension UIViewController {
    func present(_ viewControllerToPresent: UIViewController, method: Transitionable) {
        viewControllerToPresent.modalPresentationStyle = .custom
        let transitionDelegate = method.transitioningDelegate()
        viewControllerToPresent.transitioningDelegate = transitionDelegate
        viewControllerToPresent.transitioningStore = transitionDelegate
        present(viewControllerToPresent, animated: true)
    }
    
    func present(_ viewControllerToPresent: UIViewController & Transitionable) {
        present(viewControllerToPresent, method: viewControllerToPresent)
    }
    
    private var transitioningStore: UIViewControllerTransitioningDelegate? {
        set {
            objc_setAssociatedObject(self, &transitioningStoreContext, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            objc_getAssociatedObject(self, &transitioningStoreContext) as? UIViewControllerTransitioningDelegate
        }
    }
}
