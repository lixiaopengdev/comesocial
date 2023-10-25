//
//  ChatFragmentView.swift
//  CSFieldModule
//
//  Created by 于冬冬 on 2023/5/27.
//

import Foundation

class ChatFragmentView: WidgetFragmentView {
    
    lazy var chatView: ChatDetailView = {
        let view = ChatDetailView(frame: CGRect(x: 14, y: 14, width: WidgetFragment.widgetWidth - 28, height: self.chatFragment.height - 14))
        return view
    }()
    
    let headerView = TitleView(frame: .zero)
    var chatFragment: ChatFragment {
        return fragment as! ChatFragment
    }
    
    override func initialize() {
        
        headerView.frame = CGRect(x: 0, y: 0, width: WidgetFragment.widgetWidth - 28, height: 55)
        chatView.tableView.tableHeaderView = headerView
        chatView.inputSendCallback = {[weak self] message in
            self?.chatFragment.sendMessage(text: message)
        }
        chatFragment.onReceiveMessageSubject
            .sink { [weak self] (message: CSChatMessage) in
                self?.chatView.sendMessage(message: message)
                if let timeStamp = Double(message.createTime) {
                    self?.headerView.date = Date(timeIntervalSince1970: timeStamp)
                    self?.headerView.updateDateText()
                }
            }
            .store(in: &cancellableSet)
        chatFragment.onWillDisplaySubject.sink {[weak self] _ in
            self?.headerView.updateDateText()
        }.store(in: &cancellableSet)
        addSubview(chatView)
        
    }
}

extension ChatFragmentView {
    class TitleView: UIView {
        
        var date: Date?
        
        func updateDateText() {
            if let date = date {
                timeLabel.text = date.stringAgo()
            }
        }
        
        let titleLabel: UILabel = {
            let label = UILabel()
            label.textColor = .cs_softWhite
            label.font = .boldHeadline
            label.text = "Fading Texting"
            label.textAlignment = .center
            return label
        }()
        
        let timeLabel: UILabel = {
            let label = UILabel()
            label.textColor = .cs_lightGrey
            label.font = .regularFootnote
            label.textAlignment = .center

            return label
        }()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            addSubview(titleLabel)
            addSubview(timeLabel)
            
            titleLabel.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.top.equalTo(4)
            }
            timeLabel.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.top.equalTo(titleLabel.snp.bottom).offset(4)
            }
            
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }

}
