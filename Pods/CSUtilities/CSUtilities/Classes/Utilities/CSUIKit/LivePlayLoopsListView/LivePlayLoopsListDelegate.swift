//
//  LivePlayLoopsListDelegate.swift
//  CSUtilities
//
//  Created by 于冬冬 on 2023/5/17.
//

import Foundation

public protocol LivePlayLoopsListDelegate: UIScrollViewDelegate {
    
    func didSelect(livePlayView: LivePlayLoopsListView, inView: UIView, index: Int)
    
    func prefetch(livePlayView: LivePlayLoopsListView, inView: UIView, index: Int)
    /// - Returns: true可以滑动；false不可以滑动
    func checkCanScroll() -> Bool
}
