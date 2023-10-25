//
//  Image+Bundle.swift
//  Alamofire
//
//  Created by 于冬冬 on 2023/1/17.
//

import Foundation


private class BundleInternal {
    static func bundle() -> Bundle? {
        guard let url = Bundle(for: BundleInternal.self).url(forResource: "CSMeModule", withExtension: "bundle") else {
            assertionFailure("bundle is nil.....")
            return nil
        }
        return Bundle(url: url)
    }
}

extension UIImage {
    static func bundleImage(named name: String) -> UIImage? {
        guard let image = UIImage(named: name, in: BundleInternal.bundle(), compatibleWith: nil) else {
//            assertionFailure("image nil")
//            print("==========---\(BundleInternal.bundle())")

            return nil
        }
//        print("==========\(BundleInternal.bundle())")
        return image
    }
}
