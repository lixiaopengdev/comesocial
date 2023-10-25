//
//  TransitionAnimationable.swift
//  CSFieldModule
//
//  Created by 于冬冬 on 2023/4/10.
//

import Foundation

public protocol Transitionable {
    func transitioningDelegate() -> UIViewControllerTransitioningDelegate
}
