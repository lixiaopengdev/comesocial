//
//  JSEngineRegister.swift
//  Alamofire
//
//  Created by 于冬冬 on 2023/2/8.
//

import Foundation
import JSEngineKit

class JSEngineRegister {

    static let shared = JSEngineRegister()
    let nativeMethodImp = JSNativeMethodImp()
    
    func register() {
        
        YZJSEngineManager.shared().registerProvider(nativeMethodImp, with: YZNativeMethodProtocol.self)
    }

}


