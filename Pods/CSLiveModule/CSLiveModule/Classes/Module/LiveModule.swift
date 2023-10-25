//
//  LiveModule.swift
//  CSLiveModule
//
//  Created by 于冬冬 on 2023/6/20.
//

import CSMediator

public class LiveModule: MediatorModuleProtocol {
    
    public static let shared = LiveModule()
    
    public func bootstrap() {
        
        Mediator.register(LiveViewControllerService.self) { _ in
            return LiveViewControllerServiceImp()
        }
        Mediator.register(LiveTimeDewService.self) { _ in
            return LiveTimeDewServiceImp()
        }
        
    }
}
