//
//  textFragment.swift
//  Alamofire
//
//  Created by 于冬冬 on 2023/3/3.
//

import UIKit

class TextFragmentView: WidgetFragmentView {
    
    let label = UILabel()
    var textFragment: TextFragment {
        return fragment as! TextFragment
    }
    override func initialize() {
        addSubview(label)
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        label.text = textFragment.label
        label.font = textFragment.font
        label.textAlignment = textFragment.align
    }
}
