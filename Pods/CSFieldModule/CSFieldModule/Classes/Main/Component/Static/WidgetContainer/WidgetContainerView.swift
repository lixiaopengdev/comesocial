//
//  WidgetContainer.swift
//  Alamofire
//
//  Created by 于冬冬 on 2023/2/3.
//

import UIKit
import CSUtilities
import SwiftyJSON

class WidgetContainerView: FieldBaseView {
    
    lazy var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 15
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.alwaysBounceVertical = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        collectionView.keyboardDismissMode = .onDrag
        collectionView.bounces = false
        return collectionView
    }()
    
    var widgets = [WidgetComponentData]()
    
    
    override func initialize() {
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(85)
            make.bottom.equalToSuperview()
        }
    
//        guard let componentWidget = WidgetComponentData(assembly: assembly, data: facetimeData) else { return }
//        mount(componentWidget)
    }
    
    
    func mount(_ widgetData: JSON) {
        guard let widget = WidgetComponentData(assembly: assembly, data: widgetData) else {
            assertionFailure("component init failure")
            return
        }
        mount(widget)
    }
    
    func mount(_ widget: WidgetComponentData) {
        if let oldWidget = widgets.first(where: { $0.id == widget.id }) {
            HUD.showError("component already exist \(oldWidget.id)")
            return
        }
        collectionView.register(WidgetComponentCell.self, forCellWithReuseIdentifier: widget.id)
  
        collectionView.performBatchUpdates {
            let index = widgets.count
            widgets.append(widget)
            collectionView.insertItems(at: [IndexPath(item: index, section: 0)])
            widget.mount()
        } completion: { _ in
            let index = self.widgets.count - 1
            self.collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .bottom, animated: true)
        }
        
        
    }
    
    func unmount(_ widget: WidgetComponentData) {
        unmount(widget.id)
    }
    
    private func unmount(_ widgetId: String) {
        guard let index = widgets.firstIndex(where: { $0.id == widgetId }) else {
            assertionFailure("component not exist \(widgetId)")
            return
        }
        let widget = widgets.remove(at: index)
        widget.willUnmount()
        collectionView.performBatchUpdates {
            collectionView.deleteItems(at: [IndexPath(item: index, section: 0)])
            widget.didUnmount()
        }
    }
    
    func unmountAll() {
        let oldWidgets = widgets
        for widget in oldWidgets {
            widget.willUnmount()
        }
        widgets.removeAll()
        collectionView.reloadData()
        
        for widget in oldWidgets {
            widget.didUnmount()
        }
    }
    
    func updateWidget(id: String, full: JSON, change: JSON) {
        let widget = widgets.first { $0.id == id }
        widget?.update(full: full, change: change)
    }
    
    func updateUserWidget(id: String, userId: String, full: JSON, change: JSON) {
        let widget = widgets.first { $0.id == id }
        widget?.updateUser(userId: userId, full: full, change: change)
    }
    
    func updateWidget(_ widget: WidgetComponentData) {
        guard let index = widgets.firstIndex(where: { $0.id == widget.id }) else { return }
        collectionView.performBatchUpdates {
            collectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
        }
    }
    
    func receiveWidgetMessage(_ message: String) {
        guard var dicts = JSON(parseJSON:message).dictionary else {
            return
        }
        for dict in dicts {
            let widget = widgets.first { $0.id == dict.key }
            widget?.receive(widgetMessage: dict.value)
        }
    }
    
    func getWidgetWith(instanceId: String) -> WidgetComponentData? {
        let widget = widgets.first { $0.id == instanceId }
        return widget
    }
    
    override func willDestory() {
        unmountAll()
    }
    
    
}

extension WidgetContainerView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return widgets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let widget = widgets[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: widget.id, for: indexPath) as! WidgetComponentCell
        cell.updateUI(widget)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: WidgetFragment.widgetWidth, height: widgets[indexPath.row].height)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let widget = widgets[indexPath.row]
        widget.willDisplay()
    }
    
}



