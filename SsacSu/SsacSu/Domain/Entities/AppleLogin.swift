//
//  AppleLogin.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/15.
//

import Foundation

struct AppleLogin {
    let idToken: String
}

extension AppleLogin {
    func toRequest() -> AppleLoginRequestDTO {
        .init(idToken: idToken,
              // TODO: - 추후 UserDefaults에서 nickname 불러오기, deviceToken 넣어주기
              nickname: nil,
              deviceToken: nil)
    }
}
