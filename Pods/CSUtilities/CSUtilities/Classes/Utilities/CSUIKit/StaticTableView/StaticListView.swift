//
//  StaticTableView.swift
//  CSMeModule
//
//  Created by 于冬冬 on 2023/5/8.
//

import UIKit
import SnapKit

public class StaticListView: UIView {

    public var dataSource: [StaticTableViewSectionData] = []
    
    public lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedRowHeight = 61
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(StaticSectionView.self, forHeaderFooterViewReuseIdentifier: "StaticSectionViewId")
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    public func update(dataSource: [StaticTableViewSectionData]) {
        self.dataSource = dataSource
        tableView.reloadData()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("StaticListView deinit")
    }
}

extension StaticListView: UITableViewDelegate, UITableViewDataSource {
    
   public func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return dataSource[section].titleHeight
    }
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "StaticSectionViewId")
        (header as? StaticSectionView)?.updateTitle(dataSource[section].header)
        return header
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellData = dataSource[indexPath.section][indexPath.row]

        return cellData.cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellData = dataSource[indexPath.section][indexPath.row]
        cellData.cellClickCallback?(cellData)
    }
}

