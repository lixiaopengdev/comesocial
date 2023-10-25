//
//  StaticTableViewRightStyle.swift
//  CSUtilities
//
//  Created by 于冬冬 on 2023/5/8.
//

import Foundation

public typealias SwitchCallback = (Bool) -> Void
public enum StaticTableViewRightStyle {
    case text(String)
    case detail(String?)
    case switchBtn(isOn: Bool, action: SwitchCallback?)
}
