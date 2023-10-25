//
//  IgnoreFailure.swift
//  CSUtilities
//
//  Created by 于冬冬 on 2023/6/28.
//

import Combine

public extension Publisher {
    func ignoreFailure(completeImmediately: Bool = true) -> AnyPublisher<Output, Never> {
        `catch` { _ in Empty(completeImmediately: completeImmediately) }
            .eraseToAnyPublisher()
    }
}
