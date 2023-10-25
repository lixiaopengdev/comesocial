//
//  Field.swift
//  CSFieldModule
//
//  Created by 于冬冬 on 2023/6/25.
//

import CSMediator

class FieldViewControllerServiceImp: FieldViewControllerService {
    func myFieldViewController() -> UIViewController {
        let fieldId = Mediator.resolve(MeService.ProfileService.self)?.profile?.fieldId ?? 0
        return FieldViewController(id: fieldId)
    }
    
    func getFieldViewController(from fieldId: UInt) -> UIViewController {
        return FieldViewController(id: fieldId )
    }
    
    
}
