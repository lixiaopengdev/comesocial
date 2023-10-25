////
////  TimeDewCollectionViewCell.swift
////  CSListView
////
////  Created by fuhao on 2023/6/20.
////
//
//import Foundation
//
//
//class TimeDewCollectionViewCell : UICollectionViewCell {
//    let zoneView: TimeDewZoneView = {
//        let view = TimeDewZoneView()
//        view.top()
//        return view
//    }()
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        backgroundColor = .clear
//        
//        contentView.addSubview(zoneView)
//        zoneView.snp.makeConstraints { make in
//            make.top.bottom.equalToSuperview()
//            make.left.equalToSuperview().offset(12)
//            make.right.equalToSuperview().offset(-12)
//        }
//    }
//    
//    func highlight(change: Bool) {
//        zoneView.highlight(change: change)
//    }
//}
