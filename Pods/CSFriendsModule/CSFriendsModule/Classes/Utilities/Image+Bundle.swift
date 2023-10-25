//
//  Image+Bundle.swift
//  Alamofire
//
//  Created by 于冬冬 on 2023/1/17.
//

import Foundation


private class BundleInternal {
    static func bundle() -> Bundle? {
        guard let url = Bundle(for: BundleInternal.self).url(forResource: "CSFriendsModule", withExtension: "bundle") else {
            return nil
        }
        return Bundle(url: url)
    }
}

extension UIImage {
    static func bundleImage(named name: String) -> UIImage? {
        return UIImage(named: name, in: BundleInternal.bundle(), compatibleWith: nil)
    }
}
