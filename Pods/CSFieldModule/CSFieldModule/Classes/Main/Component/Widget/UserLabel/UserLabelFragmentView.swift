//
//  UserLabelFragmentView.swift
//  Alamofire
//
//  Created by 于冬冬 on 2023/3/17.
//

import CSAccountManager
import Combine

class UserLabelFragmentView: WidgetFragmentView, UITableViewDelegate, UITableViewDataSource {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.backgroundColor = nil
        tableView.separatorStyle = .none
        tableView.register(UserLabelCell.self, forCellReuseIdentifier: UserLabelCell.cellIdentifier)
        return tableView
    }()
    
    var labelUsers: [UserLabelFragment.LabelUser] = []
    var userLabelFragment: UserLabelFragment {
        return fragment as! UserLabelFragment
    }
    
    override func initialize() {
        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        userLabelFragment.$labelUsers.sink { [weak self] users in
            self?.labelUsers = users
            self?.tableView.reloadData()
        }.store(in: &cancellableSet)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return labelUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserLabelCell.cellIdentifier, for: indexPath) as! UserLabelCell
        cell.updateUser(labelUsers[indexPath.row])
        return cell
    }

    
}

extension UserLabelFragmentView {
    class UserLabelCell: UITableViewCell {
        
        let name: UILabel = {
            let label = UILabel()
            label.font = UIFont.name(.avenirNextRegular, size: 17)
            return label
        }()
        
        let label: UILabel = {
            let label = UILabel()
            label.font = UIFont.name(.avenirNextRegular, size: 17)
            label.textAlignment = .right
            return label
        }()
        
        let avatarImageView = UIImageView()
        
        var textCancle: AnyCancellable?
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            selectionStyle = .none
            backgroundColor = UIColor.clear
//            contentView.backgroundColor = nil
//            backgroundView = nil
            
//            avatarImageView.backgroundColor = .random()
            avatarImageView.layerCornerRadius = 17
            avatarImageView.image = UIImage.bundleImage(named: "avatar_placeholder")
            contentView.addSubview(name)
            contentView.addSubview(label)
            contentView.addSubview(avatarImageView)
            avatarImageView.snp.makeConstraints { make in
                make.left.equalTo(4)
                make.size.equalTo(CGSize(width: 34, height: 34))
                make.centerY.equalTo(contentView.snp.centerY)
            }
            name.snp.makeConstraints { make in
                make.left.equalTo(avatarImageView.snp.right).offset(10)
                make.centerY.equalTo(contentView.snp.centerY)
                make.width.lessThanOrEqualTo(100)
            }
            label.snp.makeConstraints { make in
                make.right.equalTo(-5)
                make.centerY.equalTo(contentView.snp.centerY)
                make.left.equalTo(name.snp.right)
            }

        }
        
        func updateUser(_ user: UserLabelFragment.LabelUser) {
            textCancle?.cancel()
            textCancle = user.$label.removeDuplicates().sink(receiveValue: { [weak self] text in
                self?.label.text = text
            })
            name.text = user.name
            if user.id == AccountManager.shared.id {
                name.textColor = UIColor(hex: 0xe6556d)
                label.textColor = UIColor(hex: 0xe6556d)
            } else {
                name.textColor = .white
                label.textColor = .white
            }
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}



