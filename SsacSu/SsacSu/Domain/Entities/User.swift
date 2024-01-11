//
//  User.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/11.
//

import Foundation

struct User {
    let email: String
    let password: String
    let nickname: String
    let phone: String
}

extension User {
    func toRequest() -> JoinRequestDTO {
        return .init(email: email,
                     password: password,
                     nickname: nickname,
                     phone: phone,
                     deviceToken: "")
    }
}


