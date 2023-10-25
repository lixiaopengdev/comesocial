////
////  RoundedBackgroundView.swift
////  CSLiveModule
////
////  Created by fuhao on 2023/6/19.
////
//
//import UIKit
//
//class RoundedBackgroundView: UICollectionReusableView {
//    
//    private var insetView: UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = .secondarySystemFill
//        view.layer.cornerRadius = 15
//        view.clipsToBounds = true
//        return view
//    }()
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        backgroundColor = .clear
//        addSubview(insetView)
//        
//        insetView.snp.makeConstraints { make in
//            make.left.right.top.bottom.equalToSuperview()
//        }
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
