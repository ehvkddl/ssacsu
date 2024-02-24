//
//  UserRepositoryImpl.swift
//  SsacSu
//
//  Created by do hee kim on 2024/02/25.
//

import Foundation

final class UserRepositoryImpl {
    
    private let networkService: NetworkService
    
    init(
        networkService: NetworkService
    ) {
        self.networkService = networkService
    }
    
}

extension UserRepositoryImpl: UserRepository {
    
    func fetchMyProfile(completion: @escaping (User) -> Void) {
        networkService.processResponse(
            api: .user(.fetchMyProfile),
            responseType: ProfileResponseDTO.self) { response in
                switch response {
                case .success(let success):
                    let user = User(userID: success.userID,
                                    email: success.email,
                                    nickname: success.nickname,
                                    profileImage: success.profileImage)
                    
                    LoginUser.shared.store(value: user)
                
                case .failure(let failure):
                    print("프로필 조회 실패", failure)
                }
            }
    }
    
}
