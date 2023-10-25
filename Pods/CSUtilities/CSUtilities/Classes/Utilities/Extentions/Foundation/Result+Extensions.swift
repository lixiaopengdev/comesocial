//
//  Result+Extensions.swift
//  CSUtilities
//
//  Created by 于冬冬 on 2023/3/29.
//

import Foundation

public extension Result {
    var isSuccess: Bool {
        guard case .success = self else { return false }
        return true
    }

    var isFailure: Bool {
        !isSuccess
    }

    var success: Success? {
        guard case let .success(value) = self else { return nil }
        return value
    }

    var failure: Failure? {
        guard case let .failure(error) = self else { return nil }
        return error
    }
}
