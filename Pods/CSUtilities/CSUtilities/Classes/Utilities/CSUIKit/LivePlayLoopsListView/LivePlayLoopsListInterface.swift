//
//  LivePlayLoopsListInterface.swift
//  CSUtilities
//
//  Created by 于冬冬 on 2023/5/17.
//

import Foundation

protocol LivePlayLoopsListInterface {
    
    /// 设置数据源
    var dataSource: LivePlayLoopsListDataSource? { get set }
    
    /// 设置代理 - 对应LTLivePlayLoopsListDelegate
    var delegate: UIScrollViewDelegate? { get set }
    
    /// 当reload的时候首次选中第几个位置，通常在reloadData前设置该属性，默认选中当前的位置
    var currentIndex: Int { get set }
    
    /// 是否开启无限轮博 默认开启
    var isCanLoops: Bool { get set }
    
    /// 更新数据源后需要调用reloadData
    func reloadData()
    
    /// 滚动到第几个位置, 调用此方法前确认已经调用reloadData
    func scrollTo(index: Int)
}
