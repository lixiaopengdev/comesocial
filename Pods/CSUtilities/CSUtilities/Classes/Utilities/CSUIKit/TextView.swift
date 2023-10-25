//
//  TextView.swift
//  CSUtilities
//
//  Created by 于冬冬 on 2023/3/21.
//

import UIKit

public class TextView: UITextView {
    
    let placeholderLabel = UILabel()
    
    public var placeholder: String = "" {
        didSet {
            placeholderLabel.text = placeholder
        }
    }
    
    public override var font: UIFont? {
        didSet {
            placeholderLabel.font = font
        }
    }
    
    public var placeholderColor: UIColor = UIColor.white.withAlphaComponent(0.5) {
        didSet {
            placeholderLabel.textColor = placeholderColor
        }
    }
    
    public override var text: String! {
        didSet {
            placeholderLabel.isHidden = !text.isEmpty
        }
    }
    
    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        configurePlaceholderLabel()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configurePlaceholderLabel()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func textDidChange(_ notification: Notification) {
        placeholderLabel.isHidden = !text.isEmpty
    }
    
    private func configurePlaceholderLabel() {
        contentInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(_:)), name: UITextView.textDidChangeNotification, object: self)
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(placeholderLabel)
        
        placeholderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5).isActive = true
        placeholderLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        placeholderLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5).isActive = true
        placeholderLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        
        placeholderLabel.textColor = placeholderColor
        placeholderLabel.font = font
        placeholderLabel.text = placeholder
        placeholderLabel.isHidden = !text.isEmpty
    }
}


