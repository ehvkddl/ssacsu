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
    
    func storeDeviceToken(fcmToken: String) {
        let request = FcmDeviceTokenRequestDTO(deviceToken: fcmToken)
        
        networkService.processResponse(api: .user(.deviceToken(fcmToken: request))) { response in
            switch response {
            case .success:
                print("deviceToken 저장 성공")
                
            case .failure(let failure):
                print("deviceToken 저장 실패", failure)
            }
        }
    }
    
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
                    
                    UserDefaultsManager.user = user
                    
                    completion(user)
                
                case .failure(let failure):
                    print("프로필 조회 실패", failure)
                }
            }
    }
    
}
