////
////  FriendsListView.swift
////  CSFriendsModule
////
////  Created by 于冬冬 on 2023/5/11.
////
//
//import Foundation
//import CSUtilities
//import CSBaseView
//
//public class CSListView: UIView {
//
//    public var rightBtnClickCallback: Action2<ItemDisplay, IndexPath>?
//    public var right1BtnClickCallback: Action2<ItemDisplay, IndexPath>?
//
//    public var cellClickCallback: Action2<ItemDisplay, IndexPath>?
//    public var sectionLeftClickCallback: Action2<SectionDisplay, Int>?
//    public var sectionRightClickCallback: Action2<SectionDisplay, Int>?
//
//    var sections: [AnySectionDisplay] = []
//
//    public lazy var tableView: UITableView = {
//        let tableView = UITableView(frame: .zero, style: .grouped)
//        tableView.backgroundColor = .clear
//        tableView.separatorStyle = .none
//        tableView.estimatedSectionFooterHeight = 0
//        tableView.keyboardDismissMode = .interactive
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.register(FriendItemCell.self, forCellReuseIdentifier: FriendItemCell.cellIdentifier)
//        tableView.register(CardsItemCell.self, forCellReuseIdentifier: CardsItemCell.cellIdentifier)
//        tableView.register(TimeDewItemCell.self, forCellReuseIdentifier: TimeDewItemCell.cellIdentifier)
//        tableView.register(FieldItemCell.self, forCellReuseIdentifier: FieldItemCell.cellIdentifier)
//        tableView.register(NoticeCell.self, forCellReuseIdentifier: NoticeCell.cellIdentifier)
//
//        tableView.register(SectionHeaderView.self, forHeaderFooterViewReuseIdentifier: SectionHeaderView.cellIdentifier)
//        return tableView
//    }()
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
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
//    public func reloadSections(_ sections: [SectionDisplay]) {
//        self.sections = sections.map({ AnySectionDisplay(display: $0) })
//        tableView.reloadData()
//    }
//
//    public func updateCell(_ item: FriendItemDisplay, _ indexPath: IndexPath) {
//
//        let section = sections[indexPath.section]
//        section.items[indexPath.row] = item
//        tableView.reloadRows(at: [indexPath], with: .automatic)
//    }
//
//    public func deleteCell(indexPath: IndexPath) {
//
//        tableView.performBatchUpdates {
//            let section = sections[indexPath.section]
//            section.items.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//            tableView.reloadData()
//        }
//
//    }
//
//    public func updateSection(_ section: SectionDisplay, _ index: Int) {
//
//        sections[index] = AnySectionDisplay(display: section)
//        tableView.reloadSections(IndexSet(integer: index), with: .automatic)
//    }
//
//    private func sectionLeftClick(_ section: SectionDisplay, _ index: Int) {
//        self.sectionLeftClickCallback?(section, index)
//    }
//
//    private func sectionRightClick(_ section: SectionDisplay, _ index: Int) {
//        self.sectionRightClickCallback?(section, index)
//    }
//
//    private func cellRightBtnClick(_ item: ItemDisplay, _ indexPath: IndexPath) {
//        self.rightBtnClickCallback?(item, indexPath)
//    }
//
//    private func cellRight1BtnClick(_ item: ItemDisplay, _ indexPath: IndexPath) {
//        self.right1BtnClickCallback?(item, indexPath)
//    }
//
//}
//
//extension CSListView: UITableViewDelegate, UITableViewDataSource {
//
//    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return sections[section].displayCount
//    }
//
//    public func numberOfSections(in tableView: UITableView) -> Int {
//        return sections.count
//    }
//
//    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let item = sections[indexPath.section].items[indexPath.row]
//        let cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath)
//        if let item = item as? FriendItemDisplay,
//           let cell = cell as? FriendItemCell {
//            cell.indexPath = indexPath
//            cell.update(item)
//            cell.rightBtnClickCallback = {[weak self] (item, indexPath) in
//                self?.cellRightBtnClick(item, indexPath)
//            }
//            cell.right1BtnClickCallback = {[weak self] (item, indexPath) in
//                self?.cellRight1BtnClick(item, indexPath)
//            }
//        } else if let item = item as? CardsItemDisplay,
//                  let cell = cell as? CardsItemCell {
//            cell.indexPath = indexPath
//            cell.update(item)
//        } else if let item = item as? TimeDewItemDisplay,
//                  let cell = cell as? TimeDewItemCell {
//            cell.indexPath = indexPath
//            cell.update(item)
//        }
//        else if let item = item as? FieldItemDisplay,
//                let cell = cell as? FieldItemCell {
//            cell.indexPath = indexPath
//            cell.update(item)
//        }
//
//        else if let item = item as? NoticeItemDisplay,
//                let cell = cell as? NoticeCell {
//            cell.indexPath = indexPath
//            cell.update(item)
//            cell.rightBtnClickCallback = {[weak self] (item, indexPath) in
//                self?.cellRightBtnClick(item, indexPath)
//            }
//        }
//        return cell
//    }
//
//    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        let item = sections[indexPath.section].items[indexPath.row]
//        return item.cellHeight
//    }
//
//    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 0.001
//    }
//
//    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        let section = sections[section]
//        if section.leftTitle == nil {
//            return 0
//        }
//        return 38
//    }
//
//    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: SectionHeaderView.cellIdentifier) as? SectionHeaderView
//        header?.updateSection(sections[section])
//        header?.index = section
//        header?.sectionLeftClickCallback = {[weak self] (section, index) in
//            self?.sectionLeftClick(section, index)
//        }
//        header?.sectionRightClickCallback = {[weak self] (section, index) in
//            self?.sectionRightClick(section, index)
//        }
//        return header
//    }
//
//    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let item = sections[indexPath.section].items[indexPath.row]
//        cellClickCallback?(item, indexPath)
//    }
//}
//
