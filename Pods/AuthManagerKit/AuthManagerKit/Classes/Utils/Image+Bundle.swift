//
//  Image+Bundle.swift
//  Alamofire
//
//  Created by 于冬冬 on 2023/4/12.
//

import Foundation


class BundleManager {
    static func bundle() -> Bundle? {
        guard let url = Bundle(for: BundleManager.self).url(forResource: "AuthManagerKit", withExtension: "bundle") else {
            return nil
        }
        return Bundle(url: url)
    }
}

public extension UIImage {
    static func bundleForImage(named name: String) -> UIImage? {
        return UIImage(named: name, in: BundleManager.bundle(), compatibleWith: nil)
    }
}
