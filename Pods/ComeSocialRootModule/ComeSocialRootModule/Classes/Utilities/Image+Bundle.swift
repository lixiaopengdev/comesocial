//
//  Image+Bundle.swift
//  CSMeModule
//
//  Created by 于冬冬 on 2023/6/20.
//

private class BundleInternal {
    static func bundle() -> Bundle? {
        guard let url = Bundle(for: BundleInternal.self).url(forResource: "ComeSocialRootModule", withExtension: "bundle") else {
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
