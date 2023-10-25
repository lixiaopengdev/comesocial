//
//  TextViewWidget.swift
//  Alamofire
//
//  Created by 于冬冬 on 2023/2/24.
//

import UIKit
import SwiftyJSON
import Combine
import CSUtilities

class TextInputFragmentView: WidgetFragmentView, UITextViewDelegate {
    
    public var maxCharactersLimit = 100
    let textView: TextView = {
        let textV = TextView()
        textV.textColor = .white
        textV.placeholder = "Please enter ..."
        textV.backgroundColor = UIColor(hex: 0x1b1b1b)
        return textV
    }()
    
    var textInputFragment: TextInputFragment {
        return fragment as! TextInputFragment
    }

    override func initialize() {
        addSubview(textView)
        backgroundColor = UIColor(hex: 0x1b1b1b)
        maxCharactersLimit = textInputFragment.limit
        textView.font = textInputFragment.font
        textView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        textInputFragment.$text.weakAssign(to: \.text, on: textView).store(in: &cancellableSet)
        textView.delegate = self

    }

    
    func textViewDidEndEditing(_ textView: UITextView) {
        if maxCharactersLimit > 0 {
            if let oriText = textView.text {
                if oriText.count > maxCharactersLimit {
                    let newText = oriText[..<oriText.index(oriText.startIndex, offsetBy: maxCharactersLimit)]
                    textView.text = String(newText)
                }
            }
        }
        if textView.text != textInputFragment.text {
            textInputFragment.syncText(textView.text)
        }
    }
}
