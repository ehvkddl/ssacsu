//
//  KakaoLogin.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/15.
//

import Foundation

struct KakaoLogin {
    let oauthToken: String
}

extension KakaoLogin {
    func toRequest() -> KakaoLoginRequestDTO {
        .init(oauthToken: oauthToken,
              deviceToken: nil)
    }
}
