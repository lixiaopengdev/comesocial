//
//  File.swift
//  CSMeModule
//
//  Created by 于冬冬 on 2023/5/5.
//

import Foundation

public class CSGradientButton: UIButton {
    
    let noiseImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.bundleImage(named: "gradient_button_noise")?.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), resizingMode: .tile)
        return imageView
    }()
    
    public var imageTextSpacing: CGFloat = 0 {
        didSet {
            titleEdgeInsets = UIEdgeInsets(top: 0, left: imageTextSpacing / 2, bottom: 0, right: -imageTextSpacing / 2)
            imageEdgeInsets = UIEdgeInsets(top: 0, left: -imageTextSpacing / 2, bottom: 0, right: imageTextSpacing / 2)
        }
    }
    
    public override var isEnabled: Bool {
        didSet {
            noiseImageView.isHidden = !isEnabled
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(noiseImageView)

        titleLabel?.font = .boldBody
        setTitleColor(.cs_pureWhite, for: .normal)
        setBackgroundImage(UIImage.bundleImage(named: "gradient_button_background"), for: .normal)
        setBackgroundColor(color: .cs_darkGrey, forState: .disabled)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        noiseImageView.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

