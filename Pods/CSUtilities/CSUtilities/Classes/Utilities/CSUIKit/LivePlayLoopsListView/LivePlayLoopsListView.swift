//
//  LivePlayLoopsListView.swift
//  CSUtilities
//
//  Created by 于冬冬 on 2023/5/17.
//

import UIKit

public class LivePlayLoopsListView: UIScrollView, LivePlayLoopsListInterface {
    
    public var isCanLoops = true
    
    public var currentIndex = 0
    
    public weak var dataSource: LivePlayLoopsListDataSource?
    
    public var contentViews: [UIView] {
        return [topView, currentView, bottomView]
    }

    override weak public var delegate: UIScrollViewDelegate? {
        didSet {
            myDelegate = delegate as? LivePlayLoopsListDelegate
        }
    }
    
    public init(frame: CGRect, content: UIView.Type) {
        self.topView = content.init()
        self.currentView = content.init()
        self.bottomView = content.init()
        super.init(frame: frame)
        itemW = frame.width
        itemH = frame.height
        setupSystem()
        setupSubViews()
    }
    
    public init(frame: CGRect, factory: ActionReturn<UIView>) {
        self.topView = factory()
        self.currentView = factory()
        self.bottomView = factory()
        super.init(frame: frame)
        itemW = frame.width
        itemH = frame.height
        setupSystem()
        setupSubViews()
    }
    
    
    public func scrollTo(index: Int) {
        _scrollTo(index: index)
    }
    
    public func reloadData() {
        _reloadData()
    }
    
    private lazy var itemW: CGFloat = 0
    private lazy var itemH: CGFloat = 0
    private lazy var totalCount = 0
    private lazy var isIgnoreOffset = false
    private var topView: UIView
    private var currentView: UIView
    private var bottomView: UIView
    private weak var myDelegate: LivePlayLoopsListDelegate?
    
    public override var contentOffset: CGPoint {
        set {
            if newValue.equalTo(self.contentOffset) {
                return
            }
            
            if let func_checkCanScroll = myDelegate?.checkCanScroll {
                let canScroll = func_checkCanScroll()
                guard canScroll else { return }
            }
            
            if !isCanLoops && isIgnoreOffset {
                if (currentIndex == totalCount - 1 && newValue.y > itemH) || currentIndex == 0 && newValue.y < itemH {
                    return
                }
            }
            
            super.contentOffset = newValue
            contentOffsetDidChanged(offset: newValue)
        }
        get { super.contentOffset }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LivePlayLoopsListView {
    
    private func setupSystem() {
        scrollsToTop = false
        contentSize = CGSize(width: itemW, height: itemH * 3.0)
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        isPagingEnabled = true
        bounces = false
        if #available(iOS 11.0, *) {
            contentInsetAdjustmentBehavior = .never
        }
    }
    
    private func setupSubViews() {
        addSubview(topView)
        addSubview(currentView)
        addSubview(bottomView)
        reset()
    }
    
    private func reset() {
        isIgnoreOffset = false
        super.contentOffset = CGPoint(x: 0, y: itemH)
        isIgnoreOffset = true
        topView.frame = CGRect(x: 0, y: 0, width: itemW, height: itemH)
        currentView.frame = CGRect(x: 0, y: itemH, width: itemW, height: itemH)
        bottomView.frame = CGRect(x: 0, y: itemH * 2, width: itemW, height: itemH)
    }
    
    private func didShow(index: Int) {
        currentIndex = cycleIndex(index: index)
        if currentIndex >= totalCount || currentIndex < 0 {
            return
        }
        myDelegate?.didSelect(livePlayView: self, inView: currentView, index: currentIndex)
    }
    
    private func cycleIndex(index: Int) -> Int {
        if !isCanLoops {
            return index
        }
        if index < 0 {
            return totalCount - 1
        }else if index >= totalCount {
            return 0
        }
        return index
    }
    
    private func prefetchingShow(view: UIView, index: Int) {
        let newIndex = cycleIndex(index: index)
        if newIndex >= totalCount || newIndex < 0 {
            return
        }
        myDelegate?.prefetch(livePlayView: self, inView: view, index: newIndex)
    }
    
    private func prefetchingNextView() {
        prefetchingShow(view: bottomView, index: currentIndex + 1)
    }
    
    private func prefetchingTopView() {
        prefetchingShow(view: topView, index: currentIndex - 1)
    }
    
    private func _scrollTo(index: Int) {
        if index >= totalCount {
            return
        }
        prefetchingShow(view: currentView, index: index)
        didShow(index: index)
        if totalCount <= 1 {
            isScrollEnabled = false
            return
        }
        prefetchingNextView()
        prefetchingTopView()
    }
    
    private func _reloadData() {
        if let count = dataSource?.numberofItems(livePlayView: self) {
            totalCount = count
            scrollTo(index: currentIndex)
        }
    }
    
    private func contentOffsetDidChanged(offset: CGPoint) {
        if offset.y >= 2 * itemH {
            isScrollEnabled = false
            (currentView, bottomView, topView) = (bottomView, topView, currentView)
            didShow(index: currentIndex + 1)
            prefetchingNextView()
            reset()
            isScrollEnabled = true
        }else if (offset.y <= 0) {
            isScrollEnabled = false
            (currentView, topView, bottomView) = (topView, bottomView, currentView)
            didShow(index: currentIndex - 1)
            prefetchingTopView()
            reset()
            isScrollEnabled = true
        }
    }
}
