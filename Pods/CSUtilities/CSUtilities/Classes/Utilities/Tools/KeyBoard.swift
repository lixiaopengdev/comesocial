//
//  KeyBoard.swift
//  CSUtilities
//
//  Created by 于冬冬 on 2023/5/25.
//

import Foundation
import Combine

public extension KeyboardAnimator {
    
    struct Info {
        public let isShow: Bool
        public var animationDuration: CGFloat = 0.25
        public var keyboardFrame: CGRect = .zero
        public var animationOptions: UIView.AnimationOptions = .curveLinear
    }
}


private extension Publisher where Output == Notification, Failure == Never  {
    
    func mapKeyboardInfo(isShow: Bool) -> AnyPublisher<KeyboardAnimator.Info, Never> {
        return map { notification in
            var keyboardInfo = KeyboardAnimator.Info(isShow: isShow)
            if let info = notification.userInfo {
                if let curve = info[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt {
                    keyboardInfo.animationOptions = UIView.AnimationOptions(rawValue: curve).union(.beginFromCurrentState)
                } else {
                    keyboardInfo.animationOptions = UIView.AnimationOptions.curveEaseOut.union(.beginFromCurrentState)
                }
                keyboardInfo.animationDuration = info[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0.25
                if let kbFrame = info[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                    keyboardInfo.keyboardFrame = kbFrame
                    if isShow {
                        KeyboardAnimator.keyboardEstimatedHeight = kbFrame.height
                    }
                }
            }
            return keyboardInfo
        }.eraseToAnyPublisher()
    }
}

public enum KeyboardAnimator {
    
    public static var keyboardEstimatedHeight: CGFloat = 346
    
    public static func publisher() -> AnyPublisher<Info, Never> {
        let showPublisher = NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification).mapKeyboardInfo(isShow: true)
        let hidePublisher = NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification).mapKeyboardInfo(isShow: false)
        return Publishers.Merge(showPublisher, hidePublisher).eraseToAnyPublisher()
    }
}
