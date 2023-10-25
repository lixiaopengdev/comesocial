//
//  PresentTransitionMethod.swift
//  CSFieldModule
//
//  Created by 于冬冬 on 2023/4/10.
//

import Foundation

public enum PresentTransitionMethod: Transitionable {
    

    case lineSheet(height: CGFloat, timeInterval: TimeInterval = 0.25)
    case bottomToTop(height: CGFloat)
    case centerIn
    public func transitioningDelegate() -> UIViewControllerTransitioningDelegate {
        switch self {
        case .lineSheet(let height, let timeInterval):
            return LineSheetTransition(height: height, timeInterval: timeInterval)
        case .bottomToTop(let height):
            return BottomToTopTransition(height: height)
        case .centerIn:
            return CenterInTransition()
        }
    }

}
