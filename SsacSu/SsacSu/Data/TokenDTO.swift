//
//  TokenDTO.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/14.
//

import Foundation

struct TokenDTO: Decodable {
    let accessToken: String
    let refreshToken: String
}
