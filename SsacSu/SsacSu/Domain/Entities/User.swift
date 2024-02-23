//
//  User.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/28.
//

import Foundation

struct User: Codable {
    let userID: Int
    let email: String
    let nickname: String
    let profileImage: String?
}
