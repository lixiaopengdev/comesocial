//
//  FieldSearchViewController.swift
//  CSFieldModule
//
//  Created by 于冬冬 on 2023/4/14.
//

import CSBaseView
import CSUtilities
import CSCommon

class FieldSearchViewController: BaseViewController {
    
//    lazy var fieldsView = CSListView()
//
//
////    lazy var sectionSuggest = FieldSearchSectionHeader(title: "Suggested")
////    lazy var sectionHistory = FieldSearchSectionHeader(title: "History", actionName: "View All")
//    lazy var searchBar = CSSearchBar()
////    var suggestSections: [FieldModel] = []
////    var historySections: [FieldModel] = []
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        let clearButton = UIButton(type: .custom)
//        clearButton.setImage(UIImage.bundleImage(named: "corner_close_dark"), for: .normal)
//        clearButton.addTarget(self, action: #selector(clearClick), for: .touchUpInside)
//
//        let scanButton = UIButton(type: .custom)
//        scanButton.setImage(UIImage.bundleImage(named: "corner_scan_dark"), for: .normal)
//        scanButton.addTarget(self, action: #selector(addClick), for: .touchUpInside)
//
//        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: scanButton), UIBarButtonItem(customView: clearButton)]
//        navigationItem.titleView = searchBar
//        view.addSubview(fieldsView)
//        fieldsView.snp.makeConstraints { make in
//            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
//            make.left.right.bottom.equalToSuperview()
//        }
//
//        var fields1: [CSCommon.FieldItemDisplay] = []
//        for index in 0...2 {
//            fields1.append(AnyFieldItemDisplay(id: UInt(index), name: "field  \(index)"))
//        }
//
//        var fields2: [CSCommon.FieldItemDisplay] = []
//        for index in 0...2 {
//            fields2.append(AnyFieldItemDisplay(id: UInt(index), name: "field  \(index)"))
//        }
//
//        let suggestSection = AnySectionDisplay(leftTitle: "Suggested", fold: nil, items: fields1)
//        let historySection = AnySectionDisplay(leftTitle: "History", rightTitle: "View All", fold: nil, items: fields1)
//
//        fieldsView.reloadSections([suggestSection, historySection])
//
//        fieldsView.cellClickCallback = {[weak self] (item, indexPath) in
//            self?.cellClick(item, indexPath)
//        }
//
//        fieldsView.sectionRightClickCallback = {[weak self] (section, index) in
//            self?.sectionClick(section, index)
//        }
//
//    }
//
//    func cellClick(_ item: ItemDisplay, _ indexPath: IndexPath) {
//        print("cellClick")
//    }
//
//    func sectionClick(_ section: SectionDisplay, _ index: Int) {
//        print("sectionClick")
//    }
//
//    @objc func clearClick() {
//        searchBar.text = nil
//    }
//
//    @objc func addClick() {
//
//    }
//
//
//
//    override var backgroundType: BackgroundType {
//        return .dark
//    }
}
