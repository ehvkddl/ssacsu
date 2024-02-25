//
//  ProfileDTO.swift
//  SsacSu
//
//  Created by do hee kim on 2024/02/25.
//

import Foundation

struct ProfileResponseDTO: Decodable {
    let userID: Int
    let email: String
    let nickname: String
    let profileImage: String?
    let phone: String?
    let vendor: String?
    let sesacCoin: Int
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case email
        case nickname
        case profileImage
        case phone
        case vendor
        case sesacCoin
        case createdAt
    }
}
