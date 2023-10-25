//
//  ProfileRelationshipViewController.swift
//  CSMeModule
//
//  Created by 于冬冬 on 2023/5/16.
//

import CSBaseView

class ProfileRelationshipViewController: BaseViewController {
    
    let headerTitle: UILabel = {
        let label = UILabel()
        label.textColor = .cs_pureWhite
        label.font = .boldFont(ofSize: 56)
        return label
    }()
    
    let relationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .cs_pureWhite
        label.font = .boldTitle1
        return label
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 48, height: 48)
        layout.minimumLineSpacing = 8
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.register(ProfileUserAvatarCell.self, forCellWithReuseIdentifier: ProfileUserAvatarCell.cellIdentifier)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    let containerView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 34
        return stackView
    }()
    
    lazy var bottomBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Request", for: .normal)
        button.titleLabel?.font = .boldBody
        button.setTitleColor(.cs_pureWhite, for: .normal)
        button.setBackgroundImage(UIImage(color: .cs_cardColorA_20, size: CGSize(width: 1, height: 1)), for: .normal)
        button.layerCornerRadius = 10
        button.addTarget(self, action: #selector(bottomBtnClick), for: .touchUpInside)
        return button
    }()
    
//    var relation: ProfileRelationDisplayType = .none
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Relationship"
        
        let button = UIButton(type: .custom)
        button.setImage(UIImage.bundleImage(named: "corner_close_dark"), for: .normal)
        button.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        
        view.addSubview(headerTitle)
        view.addSubview(relationLabel)
        view.addSubview(collectionView)
        view.addSubview(containerView)
        view.addSubview(bottomBtn)

        headerTitle.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(60)
        }
        
        relationLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(headerTitle.snp.bottom).offset(14)
        }
        
        collectionView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(relationLabel.snp.bottom).offset(24)
            make.height.equalTo(48)
            make.width.equalTo(272)
        }
        
        containerView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(collectionView.snp.bottom).offset(34)
        }

        bottomBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 250, height: 54))
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
//        
//        headerTitle.text = relation.icon
//        relationLabel.text = relation.title
        containerView.addArrangedSubview(ProfileRelationshipDesView("Push notification when in fields", right: true))
        containerView.addArrangedSubview(ProfileRelationshipDesView("Push notification when online", right: true))
        containerView.addArrangedSubview(ProfileRelationshipDesView("Display relationship", right: false))

    }
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }
    
    @objc func bottomBtnClick() {
        
    }
    
    override var backgroundType: BackgroundType {
        return .dark
    }

}

extension ProfileRelationshipViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileUserAvatarCell.cellIdentifier, for: indexPath)
        (cell as? ProfileUserAvatarCell)
        return cell
    }

}
