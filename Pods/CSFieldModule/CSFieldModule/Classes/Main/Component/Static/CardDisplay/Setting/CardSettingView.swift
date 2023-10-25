//
//  CardSettingView.swift
//  Alamofire
//
//  Created by 于冬冬 on 2023/2/16.
//

import UIKit

class CardSettingView: UIView {
    
    
    let tapView: UIView = {
        let view = UIView()
        return view
    }()
    
    let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: 0x1b1b1b)
        return view
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.layerCornerRadius = 10
        tableView.backgroundColor = UIColor(hex: 0x1b1b1b)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.bounces = false
        tableView.register(CardSettingCell.self, forCellReuseIdentifier: CardSettingCell.cellIdentifier)
        return tableView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .name(.avenirNextBold, size: 20)
        label.text = "Card Setting"
        return label
    }()
    
    let subTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hex: 0xebebf5, alpha: 0.6)
        label.font = .name(.avenirNextRegular, size: 13)
        return label
    }()
    
    
    
    init(frame: CGRect, setting: [Any]) {
        super.init(frame: .zero)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(close))
        tapView.addGestureRecognizer(tap)
        
        addSubview(tapView)
        addSubview(contentView)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(tableView)
        
        tapView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        
        contentView.snp.makeConstraints { make in
            make.left.equalTo(34)
            make.right.equalTo(-34)
            make.centerY.equalToSuperview().offset(-15)
            make.height.equalTo(457)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(23)
            make.centerX.equalToSuperview()
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(28)
            make.bottom.equalTo(-40)
            make.left.equalTo(16)
            make.right.equalTo(-16)
            
        }
        
        
        subTitleLabel.text = "Auto Photo Card"
        tableView.reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func close() {
        self.removeFromSuperview()
    }
    
}


extension CardSettingView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 51
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: CardSettingCell.cellIdentifier, for: indexPath)
        (cell as? CardSettingCell)?.updateContent(index: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
    }
    
    
}



