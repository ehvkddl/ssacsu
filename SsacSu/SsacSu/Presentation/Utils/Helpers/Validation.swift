//
//  Validation.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/14.
//

import Foundation

struct Validation {
    
    let string: String
    
    init(string: String) {
        self.string = string
    }
    
    var isEmail: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.(com|net|co\\.kr)"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: string)
    }
    
    var isPhoneNumber: Bool {
        let phnRegex = "^01[0-1, 7][0-9]{7,8}$"
        return NSPredicate(format: "SELF MATCHES %@", phnRegex).evaluate(with: string)
    }
    
    var isPassword: Bool {
        let passwordRegex = "^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[!@#$%^&*()_+=-]).{8,20}"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: string)
    }

}
