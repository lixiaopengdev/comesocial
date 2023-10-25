//
//  RegexRule.swift
//  PasswordTextField
//
//  Created by Chris Jimenez on 2/11/16.
//  Copyright © 2016 Chris Jimenez. All rights reserved.
//

import Foundation

/// Basic structure that represent a Regex Rule
open class RegexRule : Ruleable {
    
    /// Default regex
    fileprivate var REGEX: String = "^(?=.*?[A-Z]).{6,}$"
    /// Error message
    fileprivate var message : String
    
    
    /**
     Default constructor
     
     - parameter regex:   regex of the rule
     - parameter message: errorMessage
     
     - returns: <#return value description#>
     */
    public init(regex: String, errorMessage: String = "Invalid Regular Expression"){
        self.REGEX = regex
        self.message = errorMessage
    }
    
    /**
     Validates if the rule works matches
     
     - parameter value: String value to validate againts a rule
     
     - returns: if the rule is valid or not
     */
    open func validate(_ value: String) -> Bool {
        let test = NSPredicate(format: "SELF MATCHES %@", self.REGEX)
        return test.evaluate(with: value)
    }
    
    open func errorMessageDetail(_ value:String) -> Dictionary<String, Any> {
        var errorDict = Dictionary<String, Any>()
        // 验证是否包含至少一个大写字母s
        let uppercaseRegex = ".*[A-Z]+.*"
        let uppercaseTest = NSPredicate(format: "SELF MATCHES %@", uppercaseRegex)
        let containsUppercase = uppercaseTest.evaluate(with: value)
        if !containsUppercase {
            errorDict["uppercase"] = false
        }
        // 验证是否包含至少一个小写字母
        let lowercaseRegex = ".*[a-z]+.*"
        let lowercaseTest = NSPredicate(format: "SELF MATCHES %@", lowercaseRegex)
        let containsLowercase = lowercaseTest.evaluate(with: value)
        if !containsLowercase {
            errorDict["lowercase"] = false
        }
        // 验证是否包含至少一个数字
        let digitRegex = ".*\\d+.*"
        let digitTest = NSPredicate(format: "SELF MATCHES %@", digitRegex)
        let containsDigit = digitTest.evaluate(with: value)
        if !containsDigit {
            errorDict["digit"] = false
        }
        
        //验证至少6个字符
        if value.count < 6 {
            errorDict["count"] = false
        }
        return errorDict
    }
    /**
     Returns the error message
     
     - returns: <#return value description#>
     */
    open func errorMessage() -> String {
        return message
    }
    
    
    
}
