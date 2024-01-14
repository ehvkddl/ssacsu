//
//  Login.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/14.
//

import Foundation

struct Login {
    let email: String
    let password: String
}

extension Login {
    func toRequest() -> LoginRequestDTO {
        return .init(email: email, 
                     password: password,
                     deviceToken: "")
    }
}
