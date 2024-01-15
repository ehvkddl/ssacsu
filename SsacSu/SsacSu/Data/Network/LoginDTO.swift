//
//  LoginDTO.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/14.
//

import Foundation

struct LoginRequestDTO: Encodable {
    let email: String
    let password: String
    let deviceToken: String
}

struct LoginResponseDTO: Decodable {
    let userID: Int
    let email: String
    let nickname: String
    let profileImage: String?
    let phone: String?
    let vendor: String?
    let createdAt: String
    let token: TokenDTO
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case email
        case nickname
        case profileImage
        case phone
        case vendor
        case createdAt
        case token
    }
}
