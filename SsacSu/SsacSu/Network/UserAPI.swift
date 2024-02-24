//
//  UserAPI.swift
//  SsacSu
//
//  Created by do hee kim on 2024/02/25.
//

import Foundation
import Moya

enum UserAPI {
    case fetchMyProfile
}

extension UserAPI: BaseAPI {
    
    var path: String {
        switch self {
        case .fetchMyProfile: return "v1/users/my"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchMyProfile: return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .fetchMyProfile: return .requestPlain
        }
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
    
}
