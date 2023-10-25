//
//  FontManager.swift
//  CSConstants
//
//  Created by 于冬冬 on 2023/1/6.
//

import Foundation

public class FontManager {
    
    static let shared: FontManager = FontManager()
    
    init() {
        guard let url =  Bundle(for: FontManager.self).url(forResource: "CSUtilities", withExtension: "bundle") else {
            return
        }
        let fontBundle = Bundle(url: url)
        
        for fontName in FontName.allCases {
            if (fontName.rawValue.hasPrefix("Avenir")) {
                continue
            }
            guard let ttfPath = fontBundle?.url(forResource: fontName.rawValue, withExtension: "ttf") else { return }
            guard let fontData = try? Data(contentsOf: ttfPath),
                  let dataProvider = CGDataProvider(data: fontData as CFData) else { return }
            guard let fontRef = CGFont(dataProvider) else { return }
            var errorRef: Unmanaged<CFError>? = nil
            CTFontManagerRegisterGraphicsFont(fontRef, &errorRef)
            
        }
        
        //        let fys = UIFont.familyNames
        //        for fy in fys {
        //            let fts = UIFont.fontNames(forFamilyName: fy)
        //            for ft in fts {
        //                print("\(fy)=====\(ft)")
        //            }
        //        }
        
    }
    
    func name(_ fontName: FontName, size: CGFloat) -> UIFont {
        let font = UIFont(name: fontName.rawValue, size: size)
        if let font = font {
            return font
        }
        return .systemFont(ofSize: size)
    }
}

