//
//  FieldModule.swift
//  CSFieldModule
//
//  Created by 于冬冬 on 2023/6/25.
//

import CSMediator


public class FieldModule: MediatorModuleProtocol {
    
    public static let shared = FieldModule()
    
    public func bootstrap() {
        
        Mediator.register(CSMediator.FieldService.ViewControllerService.self) { _ in
            return FieldViewControllerServiceImp()
        }
    }
}
