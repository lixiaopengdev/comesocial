//
//  LivePlayLoopsListDataSource.swift
//  CSUtilities
//
//  Created by 于冬冬 on 2023/5/17.
//

import Foundation

public protocol LivePlayLoopsListDataSource: NSObjectProtocol {
    
    func numberofItems(livePlayView: LivePlayLoopsListView) -> Int
}
