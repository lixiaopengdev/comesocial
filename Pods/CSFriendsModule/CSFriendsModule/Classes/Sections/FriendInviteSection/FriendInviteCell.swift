//
//  FriendInviteCell.swift
//  CSFriendsModule
//
//  Created by 于冬冬 on 2023/6/14.
//

protocol FriendInviteCellDelegate: AnyObject {
    func friendInviteCellDidTapLinkButton(_ cell: FriendInviteCell)
    func friendInviteCellDidTapDiscoardButton(_ cell: FriendInviteCell)
    func friendInviteCellDidTapMessageButton(_ cell: FriendInviteCell)

}

final class FriendInviteCell: UICollectionViewCell {
    
    weak var delegate: FriendInviteCellDelegate?
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .cs_softWhite
        label.font = .boldBody
        label.text = "Invite via Link"
        return label
    }()
    
    let containerView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 16
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(containerView)
        
        //        let discordBtn = configButton("friends_invite_discord", method: #selector(discordClick))
        let linkBtn = configButton("friends_invite_link", method: #selector(linkClick))
        //        let messageBtn = configButton("friends_invite_message", method: #selector(messageClick))
        //        containerView.addArrangedSubview(discordBtn)
        containerView.addArrangedSubview(linkBtn)
        //        containerView.addArrangedSubview(messageBtn)
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(18)
            make.top.equalTo(18)
        }
        
        containerView.snp.makeConstraints { make in
            make.left.equalTo(18)
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configButton(_ name: String, method: Selector) -> UIButton {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage.bundleImage(named: name), for: .normal)
        btn.addTarget(self, action: method, for: .touchUpInside)
        return btn
    }
    
//    @objc func discordClick() {
////        print("discordClick")
//    }
    
    @objc func linkClick() {
        delegate?.friendInviteCellDidTapLinkButton(self)
//        UIPasteboard.general.string = linK
//        HUD.showMessage("The link has been copied to the clipboard.")
    }
    
//    @objc func messageClick() {
////        print("messageClick")
//
//    }
}
