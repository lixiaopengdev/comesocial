//
//  FieldEntryView.swift
//  CSUtilities
//
//  Created by 于冬冬 on 2023/5/17.
//

import CSBaseView
import CSUtilities

protocol FieldEntryViewDelegate: class {
    func entryTheFieldInfo(with view: FieldEntryView)
    func entryTheField(with view: FieldEntryView)
}

class FieldEntryView: UIView {
    
    private let fieldHideView = FieldHidenPromptView()
    private var viewController: UIViewController?
    var field: FieldModel?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .cs_pureWhite
        label.font = .boldLargeTitle
        label.text = " "
        return label
    }()
    
    private let usersView = FieldEntryUsersView()
    private let fieldContentView = FieldEntryContentView()
    private let contentLayoutGuaide = UILayoutGuide()
    
    weak var delegate: FieldEntryViewDelegate?
    
    init(viewController: UIViewController?) {
        super.init(frame: .zero)
        self.viewController = viewController
        
        addLayoutGuide(contentLayoutGuaide)
        contentLayoutGuaide.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaInsets)
        }
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        
        usersView.usersClickCallback = {[weak self] in
            guard let self = self else { return }
            self.delegate?.entryTheFieldInfo(with: self)
        }
        
        fieldContentView.contentClickCallback = {[weak self] in
            guard let self = self else { return }
            self.delegate?.entryTheField(with: self)
        }
        
        addSubview(titleLabel)
        addSubview(usersView)
        addSubview(fieldContentView)
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.top.equalTo(contentLayoutGuaide.snp.top).offset(14)
        }
        usersView.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.top.equalTo(titleLabel.snp.bottom)
            make.height.equalTo(26)
            make.right.equalTo(-50)
        }
        
        fieldContentView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(usersView.snp.bottom).offset(24)
            make.bottom.equalTo(contentLayoutGuaide.snp.bottom).offset(-75)
        }
        
    }
    
    func updateSafeAreaInset(_ inset: UIEdgeInsets) {

        contentLayoutGuaide.snp.remakeConstraints { make in
            make.edges.equalTo(inset)
        }
    }
    
    func update(_ field: FieldModel) {
        self.field = field
        titleLabel.text = field.name
    }
    
    func hide() {
        fieldHideView.show(in: self)
    }

}
