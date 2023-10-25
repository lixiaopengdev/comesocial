//
//  StationaryChatFragmentView.swift
//  Alamofire
//
//  Created by 于冬冬 on 2023/3/17.
//

import CSAccountManager
import Combine
import CSUtilities

class StationaryChatFragmentView: WidgetFragmentView, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    
    public var maxCharactersLimit = -1
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.backgroundColor = nil
        tableView.separatorStyle = .none
        tableView.register(StationaryChatCell.self, forCellReuseIdentifier: StationaryChatCell.cellIdentifier)
        return tableView
    }()
    
    var chatUsers: [StationaryChatFragment.StationaryChatUser] = []
    var stationaryChatFragment: StationaryChatFragment {
        return fragment as! StationaryChatFragment
    }
    
    override func initialize() {
        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        stationaryChatFragment.$chatUsers.sink { [weak self] users in
            self?.chatUsers = users
            self?.tableView.reloadData()
        }.store(in: &cancellableSet)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StationaryChatCell.cellIdentifier, for: indexPath) as! StationaryChatCell
        cell.updateUser(chatUsers[indexPath.row])
        cell.textView.delegate = self
        return cell
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if maxCharactersLimit > 0 {
            if let oriText = textView.text {
                if oriText.count > maxCharactersLimit {
                    let newText = oriText[..<oriText.index(oriText.startIndex, offsetBy: maxCharactersLimit)]
                    textView.text = String(newText)
                }
            }
        }
        stationaryChatFragment.syncText(textView.text)

    }
    
}

class StationaryChatCell: UITableViewCell {
    
    let textView: TextView = {
        let textV = TextView()
        textV.textColor = .white
        textV.font = UIFont.name(.avenirNextRegular, size: 17)
        textV.isScrollEnabled = false
        textV.placeholder = "Please enter ..."
        return textV
    }()
    
    let avatarImageView = UIImageView()
    
    var textCancle: AnyCancellable?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = UIColor.clear
//        avatarImageView.backgroundColor = .random()
        avatarImageView.image = UIImage.bundleImage(named: "avatar_placeholder")
        avatarImageView.layerCornerRadius = 17
        textView.layerCornerRadius = 17
        contentView.addSubview(textView)
        contentView.addSubview(avatarImageView)
      
    }
    
    func updateUser(_ user: StationaryChatFragment.StationaryChatUser) {
        textCancle?.cancel()
        textCancle = user.$message.removeDuplicates().sink(receiveValue: { [weak self] text in
            self?.textView.text = text
        })
        if user.id == AccountManager.shared.id {
            textView.isUserInteractionEnabled = true
            textView.backgroundColor = UIColor(hex: 0xe6556d)
            avatarImageView.snp.remakeConstraints { make in
                make.right.equalToSuperview()
                make.size.equalTo(CGSize(width: 34, height: 34))
                make.top.equalTo(0)
            }
            textView.snp.remakeConstraints { make in
                make.right.equalTo(avatarImageView.snp.left).offset(-5)
                make.left.equalTo(65)
                make.height.equalTo(36)
                make.top.equalTo(avatarImageView.snp.top)
            }
        } else {
            textView.isUserInteractionEnabled = false
            textView.backgroundColor = UIColor(hex: 0x1b1b1b)
            avatarImageView.snp.remakeConstraints { make in
                make.left.equalToSuperview()
                make.size.equalTo(CGSize(width: 34, height: 34))
                make.top.equalTo(0)
            }
            textView.snp.remakeConstraints { make in
                make.left.equalTo(avatarImageView.snp.right).offset(5)
                make.right.equalTo(-65)
                make.height.equalTo(36)
                make.top.equalTo(avatarImageView.snp.top)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
