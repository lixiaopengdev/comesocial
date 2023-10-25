//
//  FieldShareQRCodeViewController.swift
//  CSFieldModule
//
//  Created by 于冬冬 on 2023/4/14.
//

import UIKit
import CSBaseView
import EFQRCode

class FieldShareQRCodeViewController: BaseViewController {
    
    let contentView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.bundleImage(named: "field_share_white_rect")
        return imageView
    }()
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.bundleImage(named: "field_share_icon")
        imageView.backgroundColor = UIColor(hex: 0x0f0f0f)
        imageView.layerCornerRadius = 24
        return imageView
    }()
    
    let codeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layerCornerRadius = 10
        imageView.backgroundColor = .cs_darkGrey
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .cs_darkBlue
        label.font = .boldTitle1
        label.textAlignment = .center
        label.text = "Cathy Pink's Field"
        return label
    }()
    
    let subTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .cs_decoMidPurple
        label.font = UIFont.name(.nunitoSansSemiBold, size: 8)
        label.textAlignment = .center
        label.text = "FIELD SHARED ON FEBRUARY 6"
        return label
    }()
    
    let desLabel: UILabel = {
        let label = UILabel()
        label.textColor = .cs_decoLightPurple
        label.font = .regularFootnote
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "People can scan this QR code with their smartphone’s camera to see this field."
        return label
    }()
    
    lazy var closeBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage.bundleImage(named: "field_share_close"), for: .normal)
        button.addTarget(self, action: #selector(closeVC), for: .touchUpInside)
        return button
    }()
    
    lazy var saveBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage.bundleImage(named: "field_share_download"), for: .normal)
        button.addTarget(self, action: #selector(saveImage), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(contentView)
        view.addSubview(desLabel)
        view.addSubview(closeBtn)
        view.addSubview(saveBtn)
        
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitleLabel)
        
        iconImageView.addSubview(codeImageView)
        
        contentView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(view.snp.centerY).offset(-55)
            make.size.equalTo(CGSize(width: 270, height: 361))
        }
        desLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(contentView.snp.bottom).offset(33)
            make.width.equalTo(225)
        }
        closeBtn.snp.makeConstraints { make in
            make.right.equalTo(view.snp.centerX).offset(-16)
            make.top.equalTo(desLabel.snp.bottom).offset(48)
            make.size.equalTo(CGSize(width: 60, height: 60))
        }
        saveBtn.snp.makeConstraints { make in
            make.left.equalTo(view.snp.centerX).offset(16)
            make.top.equalTo(closeBtn.snp.top)
            make.size.equalTo(CGSize(width: 60, height: 60))
        }
        
        iconImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(8)
            make.size.equalTo(CGSize(width: 254, height: 279))
        }
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.top.equalTo(iconImageView.snp.bottom).offset(14)
        }
        subTitleLabel.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
        }
        
        codeImageView.snp.makeConstraints { make in
            make.top.equalTo(15)
            make.left.equalTo(12)
            make.size.equalTo(CGSize(width: 41, height: 41))
        }
        
        DispatchQueue.global().async {
            if let cgImage = EFQRCode.generate(for: "test", watermark: UIImage.bundleImage(named: "field_share_icon")?.cgImage) {
                let image = UIImage(cgImage: cgImage)
                DispatchQueue.main.async {
                    self.codeImageView.image = image
                }
            }
        }
     
        
    }
    
    override var backgroundType: BackgroundType {
        return .dark
    }
    
    @objc func closeVC() {
       
        dismiss(animated: true)
    }
    
    @objc func saveImage() {
        
    }
    
}
