//
//  UserDTO.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/28.
//

import Foundation

struct UserResponseDTO: Decodable {
    let userID: Int
    let email: String
    let nickname: String
    let profileImage: String?
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case email
        case nickname
        case profileImage
    }
}

extension UserResponseDTO {
    func toDomain() -> User {
        return .init(userID: userID,
                     email: email,
                     nickname: nickname,
                     profileImage: profileImage)
    }
}
