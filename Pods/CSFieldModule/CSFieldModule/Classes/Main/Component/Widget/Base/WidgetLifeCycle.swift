//
//  WidgetLifeCycle.swift
//  CSFieldModule
//
//  Created by 于冬冬 on 2023/6/2.
//

import Foundation

protocol WidgetLifeCycle {
    
    func mount()
    func willDisplay()
    func willUnmount()
    func didUnmount()
}

protocol FragmentLifeCycle {
    func initialize()
    
    func mount()
    func willDisplay()
    func willUnmount()
    func didUnmount()
}
