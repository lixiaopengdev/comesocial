//
//  ProfileView.swift
//  CSRouter
//
//  Created by 于冬冬 on 2023/5/15.
//

//import Foundation
//import CSUtilities
//
//class ProfileView: UIView {
//    
//    private var sections:[ProfileViewModel] = []
//
//    var clickRelationItemCallback: Action1<ProfileRelationDisplayType>?
//    var switchValueChangedCallback: Action1<Bool>?
//    var clickHeadButtonCallback: Action?
//
//
//    private lazy var tableView: UITableView = {
//        let tableView = UITableView(frame: .zero, style: .grouped)
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.backgroundColor = .clear
//        tableView.separatorStyle = .none
//        tableView.estimatedSectionFooterHeight = 0
//        tableView.register(ProfileCollectionCell.self, forCellReuseIdentifier: ProfileCollectionCell.cellIdentifier)
//        tableView.register(ProfileHeaderCell.self, forCellReuseIdentifier: ProfileHeaderCell.cellIdentifier)
//        tableView.register(ProfileRelationshipCell.self, forCellReuseIdentifier: ProfileRelationshipCell.cellIdentifier)
//
//        tableView.register(ProfileSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: ProfileSectionHeaderView.cellIdentifier)
//        return tableView
//    }()
//
//    func setSections(_ sections: [ProfileViewModel]) {
//        self.sections = sections
//        tableView.reloadData()
//    }
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        addSubview(tableView)
//        tableView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//
//}
//
//extension ProfileView: UITableViewDelegate, UITableViewDataSource {
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        print(sections.count)
//        return sections.count
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print(sections[section].count)
//
//        return sections[section].count
//    }
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        let section = sections[section]
//        return section.headerHeight
//    }
//
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 0.001
//    }
//
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let section = sections[section]
//        if let header = section.header {
//            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: ProfileSectionHeaderView.cellIdentifier) as? ProfileSectionHeaderView
//            headerView?.switchValueChangedCallback = {[weak self] value in
//                self?.switchValueChangedCallback?(value)
//            }
//            headerView?.update(header)
//            return headerView
//        }
//        return nil
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return sections[indexPath.section].cellHeight(index: indexPath.row)
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        let section = sections[indexPath.section]
//        let cell = tableView.dequeueReusableCell(withIdentifier: section.cellIdentifier, for: indexPath)
//        switch section {
//        case .header(let user):
//            (cell as? ProfileHeaderCell)?.update(user: user)
//            (cell as? ProfileHeaderCell)?.clickHeadButtonCallback = {[weak self] in
//                self?.clickHeadButtonCallback?()
//            }
//        case .relationShip:
//            (cell as? ProfileRelationshipCell)?.clickItemCallback = {[weak self] itemType in
//                self?.clickRelationItemCallback?(itemType)
//            }
//        case .collection(_, let items):
//            let title = items[indexPath.row]
//            (cell as? ProfileCollectionCell)?.update(title)
//        }
//        return cell
//    }
//
//
//
//}
