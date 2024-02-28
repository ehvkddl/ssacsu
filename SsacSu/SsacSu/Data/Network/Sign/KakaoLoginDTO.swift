//
//  KakaoLoginRequestDTO.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/15.
//

import Foundation

struct KakaoLoginRequestDTO: Encodable {
    let oauthToken: String
    let deviceToken: String?
}

struct KakaoLoginResponseDTO: Decodable  {
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

extension KakaoLoginResponseDTO {
    func toDomain() -> Login {
        return .init(userID: userID,
                     email: email,
                     nickname: nickname,
                     profileImage: profileImage,
                     phone: phone,
                     vendor: vendor,
                     createdAt: createdAt,
                     token: token)
    }
}
