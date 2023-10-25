//
//  Router.swift
//  CSRouter
//
//  Created by 于冬冬 on 2023/1/9.
//

import URLNavigator

public typealias RouterProtocol = URLNavigator.NavigatorProtocol
public typealias ViewControllerFactory = URLNavigator.ViewControllerFactory
public typealias URLConvertible = URLNavigator.URLConvertible


public class Router: Navigator {
    
    public static let shared = Router()
    private override init() {
         
    }
    
}



