//
//  ConverterType.swift
//  come_social_media_tools_ios
//
//  Created by 于冬冬 on 2023/3/20.
//

import Foundation

public enum ConverterType: String {
    case child
    case female
    case male
    case ogre
    
    func converterType() -> AudioProcessor.Type {
        
        switch self {
        case .child:
            return AudioChildConverter.self
        case .female:
            return AudioFemaleConverter.self
        case .male:
            return AudioMaleConverter.self
        case .ogre:
            return AudioOgreConverter.self
        }
    }
}
