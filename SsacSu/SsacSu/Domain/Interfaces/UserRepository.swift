//
//  UserRepository.swift
//  SsacSu
//
//  Created by do hee kim on 2024/02/25.
//

import Foundation

protocol UserRepository {
    func storeDeviceToken(fcmToken: String)
    func fetchMyProfile(completion: @escaping (User) -> Void)
}
