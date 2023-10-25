//
//  FieldHidenPromptView.swift
//  CSFieldModule
//
//  Created by 于冬冬 on 2023/4/11.
//

import UIKit
import CSBaseView

class FieldHidenPromptView: UIView {

    let headerIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.bundleImage(named: "hide_icon")
        return imageView
    }()
    
    let desLabel: UILabel = {
        let label = UILabel()
        label.textColor = .cs_darkGrey
        label.font = .regularFootnote
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "This field has been hidden. You’ll see field like this lower in your feed."
        return label
    }()
    
    let stackContainer: UIStackView =  {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        alpha = 0
        
        let backgroundView = BrilliantBackgroundView(type: .light)
        addSubview(backgroundView)
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        addSubview(stackContainer)
        stackContainer.snp_makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(141)
        }
        
        stackContainer.addArrangedSubview(headerIcon)
        headerIcon.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 174, height: 174))
        }
        stackContainer.setCustomSpacing(15, after: headerIcon)
        
        stackContainer.addArrangedSubview(desLabel)
        desLabel.snp.makeConstraints { make in
            make.width.equalTo(225)
        }
        stackContainer.setCustomSpacing(24, after: desLabel)
        let reportButton = addButton(title: "Report this field", color: .cs_warningRed)
        let avoidButton = addButton(title: "Avoid this card set/effect", color: .cs_softWhite2)
        let muteButton = addButton(title: "Mute Cathy Pink (host)", color: .cs_softWhite2)
        let undoButton = addButton(title: "Undo", color: .cs_warningRed)
        
        undoButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
    }
    
    func addButton(title: String, color: UIColor) -> UIButton {
        let lineView = UIView()
        lineView.backgroundColor = .cs_decoDarkPurple

        let button = UIButton(type: .custom)
        button.setTitle(title, for: .normal)
        button.setTitleColor(color, for: .normal)
        button.titleLabel?.font = .boldBody

        stackContainer.addArrangedSubview(lineView)
        stackContainer.addArrangedSubview(button)
        
        lineView.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(0.5)
        }
        button.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(62)
        }
        return button
    }
    
    func show(in superView: UIView) {
        superView.addSubview(self)
        self.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        UIView.animate(withDuration: 0.35) {
            self.alpha = 1
        }
    }
    
    @objc func dismiss() {
        UIView.animate(withDuration: 0.35) {
            self.alpha = 0
        } completion: { _ in
            self.removeFromSuperview()
        }

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
