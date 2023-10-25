//
//  FaceTimeMediaControllerView.swift
//  CSFieldModule
//
//  Created by 于冬冬 on 2023/6/2.
//

import Foundation

class FaceTimeMediaControllerView: UIView {
    
    lazy var micBtn: UIButton = {
        let button = UIButton(type: .custom)
        return button
    }()
    
    lazy var cameraBtn: UIButton = {
        let button = UIButton(type: .custom)
        return button
    }()
    
    lazy var switchCameraBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage.bundleImage(named: "media_controller_flip_on"), for: .normal)
        return button
    }()
    
    var micOpen: Bool = false {
        didSet {
            micBtn.setImage(UIImage.bundleImage(named: micOpen ? "media_controller_microphone_on" : "media_controller_microphone_off"), for: .normal)
        }
    }
    var cameraOpen: Bool = false {
        didSet {
            cameraBtn.setImage(UIImage.bundleImage(named: cameraOpen ? "media_controller_video_on" : "media_controller_video_off"), for: .normal)
        }
    }
    
    let container: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 18
        return stackView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        layerCornerRadius = 25
        backgroundColor = .cs_cardColorA_40
        addSubview(container)
        container.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 6))
        }
        container.addArrangedSubviews([micBtn, cameraBtn, switchCameraBtn])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
