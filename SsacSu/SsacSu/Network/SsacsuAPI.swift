//
//  SsacsuAPI.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/10.
//

import Foundation
import Moya

enum SsacsuAPI {
    case checkEmailValidation(email: EmailValidationRequestDTO)
    case join(join: JoinRequestDTO)
    case login(login: LoginRequestDTO)
    case appleLogin(login: AppleLoginRequestDTO)
}

extension SsacsuAPI: TargetType {
    
    var baseURL: URL {
        URL(string: Configurations.baseURL)!
    }
    
    var path: String {
        switch self {
        case .checkEmailValidation: return "v1/users/validation/email"
        case .join: return "v1/users/join"
        case .login: return "v2/users/login"
        case .appleLogin: return "v1/users/login/apple"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .checkEmailValidation, .join, .login, .appleLogin: return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .checkEmailValidation(let email):
            return .requestJSONEncodable(email)
        case .join(let join):
            return .requestJSONEncodable(join)
        case .login(let login):
            return .requestJSONEncodable(login)
        case .appleLogin(let login):
            return .requestJSONEncodable(login)
        }
    }
    
    var headers: [String : String]? {
        [
            "Content-Type": "application/json",
            "SesacKey": Configurations.SeSACKey
        ]
    }
    
}
