//
//  WidgetCell.swift
//  CSFriendsModule
//
//  Created by 于冬冬 on 2023/3/15.
//

import UIKit
import CSUtilities
import CSLogger
import Combine

private let spacing: CGFloat = 15

class WidgetComponentCell: UICollectionViewCell {
    
    var widgetWrapper: WeakWrapper<WidgetComponentData>?
    
    var widget: WidgetComponentData? {
        return widgetWrapper?.value
    }
    
    let contentStack: FragementStackView = {
        let stackView = FragementStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        return stackView
    }()
    let topStack: FragementStackView = {
        let stackView = FragementStackView()
        stackView.axis = .vertical
        stackView.spacing = spacing
        stackView.distribution = .fillProportionally
//        stackView.alignment = .center
        return stackView
    }()
    let midStack: FragementStackView = {
        let stackView = FragementStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        return stackView
    }()
    let bottomStack: FragementStackView = {
        let stackView = FragementStackView()
        stackView.axis = .vertical
        stackView.spacing = spacing
        stackView.distribution = .fillProportionally

        return stackView
    }()
    let trailingStack: FragementStackView = {
        let stackView = FragementStackView()
        stackView.axis = .vertical
        stackView.spacing = spacing
        stackView.distribution = .fillProportionally

        return stackView
    }()
    let leadingStack: FragementStackView = {
        let stackView = FragementStackView()
        stackView.axis = .vertical
        stackView.spacing = spacing
        stackView.distribution = .fillProportionally

        return stackView
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layerCornerRadius = 14
//        backgroundColor = .random()
        contentView.addSubview(contentStack)
        contentStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentStack.addArrangedSubview(topStack)
        contentStack.addArrangedSubview(midStack)
        contentStack.addArrangedSubview(bottomStack)
        
        midStack.addArrangedSubview(leadingStack)
        midStack.addArrangedSubview(trailingStack)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpWithData() {
        guard let widget = widget else { return }
        for fragment in widget.top {
            topStack.addArrangedSubview(fragment.buildView())
        }
        for fragment in widget.bottom {
            bottomStack.addArrangedSubview(fragment.buildView())
        }
        for fragment in widget.leading {
            leadingStack.addArrangedSubview(fragment.buildView())
        }
        for fragment in widget.trailing {
            trailingStack.addArrangedSubview(fragment.buildView())
        }
        
    }
    
    func updateUI(_ widget: WidgetComponentData) {
        if self.widget?.id == widget.id {
            return
        }
        if self.widgetWrapper != nil {
            stackClear()
        }
        
        self.widgetWrapper = WeakWrapper(widget)
        setUpWithData()
    }
    
    private func stackClear() {
        topStack.clear()
        trailingStack.clear()
        leadingStack.clear()
        bottomStack.clear()
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        logger.info(size)
        return size
    }

}
