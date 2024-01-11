//
//  String+.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/12.
//

import Foundation

extension String {
    
    var withHypen: String {
        let cleanedPhoneNumber = self.filter { $0.isNumber }
        var formattedPhoneNumber = ""
        
        for (index, char) in cleanedPhoneNumber.enumerated() {
            if index == 3 || (index == 6 && cleanedPhoneNumber.count <= 10) || (index == 7 && cleanedPhoneNumber.count > 10) {
                formattedPhoneNumber += "-"
            }
            formattedPhoneNumber += String(char)
        }
        
        return formattedPhoneNumber
    }
    
    var withoutHypen: String {
        let cleandPhoneNumber = self.filter { $0.isNumber }
        
        return cleandPhoneNumber
    }
    
}
