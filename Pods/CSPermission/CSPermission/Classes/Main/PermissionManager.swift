//
//  PermissionManager.swift
//  CSPermission
//
//  Created by 于冬冬 on 2023/6/21.
//

import Foundation
import Permission

public typealias SysPermission = Permission

public class PermissionManager {
    public static let shared = PermissionManager()
    @Published public var timeDewAuthorized = false

}
