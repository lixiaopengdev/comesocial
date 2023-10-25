////
////  ProfileRelationItemView.swift
////  CSMeModule
////
////  Created by 于冬冬 on 2023/5/16.
////
//
//import CSUtilities
//
//class ProfileRelationItemView: UIButton {
//    
//    private var relationship: ProfileRelationDisplayType = .none
//    var clickCallback: Action1<ProfileRelationDisplayType>?
//    
//    let iconLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = .cs_pureWhite
//        label.font = .boldTitle1
//        return label
//    }()
//    
//    let relationLabel: UILabel = {
//        let label = UILabel()
//        label.font = .regularSubheadline
//        return label
//    }()
//    
//    let detailLabel: UILabel = {
//        let label = UILabel()
//        label.font = .regularCaption1
//        return label
//    }()
//    
//    let containerView: UIStackView = {
//        let stackView = UIStackView()
//        stackView.axis = .vertical
//        stackView.alignment = .center
//        stackView.distribution = .fill
//        stackView.isUserInteractionEnabled = false
//        return stackView
//    }()
//    
//    let backgroundImageView: UIImageView = {
//        let imageView = UIImageView()
//        return imageView
//    }()
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        
//        addSubview(backgroundImageView)
//        addSubview(containerView)
//        
//        containerView.addArrangedSubview(iconLabel)
//        containerView.addArrangedSubview(relationLabel)
//        containerView.addArrangedSubview(detailLabel)
//        
//        containerView.snp.makeConstraints { make in
//            make.left.right.equalToSuperview()
//            make.centerY.equalToSuperview()
//        }
//        backgroundImageView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
//        
//        containerView.setCustomSpacing(5, after: iconLabel)
//        containerView.setCustomSpacing(1, after: relationLabel)
//        containerView.setCustomSpacing(12, after: detailLabel)
//
//        addTarget(self, action: #selector(itemClick), for: .touchUpInside)
//    }
//    
//    @objc func itemClick() {
//        clickCallback?(relationship)
//    }
//    
//    func update(_ relationship: ProfileRelationDisplayType, active: Bool) {
//        self.relationship = relationship
//        
//        relationLabel.text = relationship.title
//        detailLabel.text = relationship.subtitle
//        iconLabel.text = relationship.icon
//        
//        relationLabel.textColor = active ? UIColor.cs_pureWhite : UIColor.cs_lightGrey
//        detailLabel.textColor = active ? UIColor.cs_decoLightPurple : UIColor.cs_lightGrey
//        backgroundImageView.image = active ? UIImage.bundleImage(named: "gradient_button_rect_border_highlight") : UIImage.bundleImage(named: "gradient_button_rect_border")
//        
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
