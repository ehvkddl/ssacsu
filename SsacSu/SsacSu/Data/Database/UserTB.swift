//
//  UserTB.swift
//  SsacSu
//
//  Created by do hee kim on 2024/02/22.
//

import Foundation

import RealmSwift

final class UserTB: Object {
    @Persisted(primaryKey: true) var userID: Int
    @Persisted var email: String
    @Persisted var nickname: String
    @Persisted var profileImage: String?
    
    convenience init(
        userID: Int,
        email: String,
        nickname: String,
        profileImage: String? = nil
    ) {
        self.init()
        
        self.userID = userID
        self.email = email
        self.nickname = nickname
        self.profileImage = profileImage
    }
}
