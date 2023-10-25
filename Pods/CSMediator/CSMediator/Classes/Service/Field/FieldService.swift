//
//  FieldCommonService.swift
//  CSMediator
//
//  Created by 于冬冬 on 2023/6/20.
//

public protocol FieldViewControllerService {
    func myFieldViewController() -> UIViewController
    func getFieldViewController(from fieldId: UInt) -> UIViewController
}

public enum FieldService {
    
    public typealias ViewControllerService = FieldViewControllerService
    
}
