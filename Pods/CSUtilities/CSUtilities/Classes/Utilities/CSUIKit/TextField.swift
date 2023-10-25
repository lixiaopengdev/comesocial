//
//  TextField.swift
//  comesocial
//
//  Created by 于冬冬 on 2022/11/28.
//

import UIKit

public class TextField: UITextField {
    
    public typealias TextDidChangeCallback = (TextField) -> Void
    
    public var contentEdgeInsets = UIEdgeInsets.zero
    public var maxCharactersLimit = 0
    
    lazy var customClearButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage.bundleImage(named: "mini_icon_oio"), for: .normal)
        button.addTarget(self, action: #selector(clearText), for: .touchUpInside)
        return button
    }()
    
    public var textDidChangeCallback: TextDidChangeCallback?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: UITextField.textDidChangeNotification, object: self)
        tintColor = .cs_primaryPink
        rightView = customClearButton
        keyboardAppearance = .dark

    }
    
    
    @objc func textDidChange() {
        if maxCharactersLimit > 0 {
            if let oriText = text {
                if oriText.count > maxCharactersLimit {
                    let newText = oriText[..<oriText.index(oriText.startIndex, offsetBy: maxCharactersLimit)]
                    text = String(newText)
                }
            }
        }
        textDidChangeCallback?(self)
    }
    
    @objc func clearText() {
        text = ""
        textDidChange()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return calculateRect(forOri: rect)
    }
    
    public override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return calculateRect(forOri: rect)
    }
    
    private func calculateRect(forOri rect: CGRect) -> CGRect {
        return CGRect(x: rect.minX + contentEdgeInsets.left,
                      y: rect.minY + contentEdgeInsets.top,
                      width: rect.width - contentEdgeInsets.left - contentEdgeInsets.right,
                      height: rect.height - contentEdgeInsets.top - contentEdgeInsets.bottom)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
}
