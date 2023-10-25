//
//  BackgroundView.swift
//  CSBaseView
//
//  Created by 于冬冬 on 2023/4/13.
//

import Foundation
import CSUtilities

public class BrilliantBackgroundView: UIView {
    
    private lazy var backgroundImageView: UIImageView = {
        let backgroundImageView = UIImageView()
        backgroundImageView.image = UIImage.bundleImage(named: "background")
        self.addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(Device.UI.screenWidth / 390 * 230 )
        }
        return backgroundImageView
    }()
    
    public init(type: BackgroundType) {

        super.init(frame: .zero)
        switch type {
        case .none:
            break
        case .light:
            configureWithLightBackground()
        case .dark:
            configureWithDarkBackground()
        }
    }
    
    private func configureWithLightBackground() {
        backgroundColor = .cs_primaryBlack
        backgroundImageView.image = UIImage.bundleImage(named: "background_light")
    }

    private func configureWithDarkBackground() {
        backgroundColor = .cs_darkBlue
        backgroundImageView.image = UIImage.bundleImage(named: "background_dark")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
