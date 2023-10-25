//
//  ThanksReportViewController.swift
//  CSFieldModule
//
//  Created by 于冬冬 on 2023/4/11.
//

import CSBaseView
import CSUtilities

class ThanksReportViewController: BaseViewController {
    
    let headerIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.bundleImage(named: "report_thanks_icon")
        return imageView
    }()
    
    let headerTitle: UILabel = {
        let label = UILabel()
        label.textColor = .cs_softWhite
        label.font = .boldTitle1
        return label
    }()
    
    let desLabel: UILabel = {
        let label = UILabel()
        label.textColor = .cs_decoLightPurple
        label.font = .regularFootnote
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    lazy var nextBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Next", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(nextClick), for: .touchUpInside)
        button.titleLabel?.font = .boldBody
        button.layerCornerRadius = 10
        button.setBackgroundColor(color: .cs_3D3A66_20, forState: .normal)
        return button
    }()
    
    let type: FeedbackType
    
    public init(type: FeedbackType) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = type.display.title
        headerTitle.text = type.display.thanksContent
        desLabel.text = type.display.thanksDes(type: type)
        let button = UIButton(type: .custom)
        button.setImage(UIImage.bundleImage(named: "corner_close_dark"), for: .normal)
        button.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        navigationItem.hidesBackButton = true
        
        view.addSubview(headerTitle)
        view.addSubview(headerIcon)
        view.addSubview(desLabel)
        view.addSubview(nextBtn)
        
        headerTitle.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(138)
        }
        
        headerIcon.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(headerTitle.snp.bottom).offset(32)
            make.size.equalTo(CGSize(width: 182, height: 182))
        }
        
        desLabel.snp.makeConstraints { make in
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.top.equalTo(headerIcon.snp.bottom).offset(32)
        }
        
        nextBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-46)
            make.size.equalTo(CGSize(width: 250, height: 54))
        }
        
        
    }
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }
    
    override var backgroundType: BackgroundType {
        return .dark
    }
    
    @objc func nextClick() {
        dismiss(animated: true)
    }
}
