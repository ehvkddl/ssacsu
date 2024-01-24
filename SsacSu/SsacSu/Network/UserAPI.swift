//
//  SsacsuAPI.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/10.
//

import Foundation
import Moya

enum UserAPI {
    case checkEmailValidation(email: EmailValidationRequestDTO)
    case join(join: JoinRequestDTO)
    case login(login: LoginRequestDTO)
    case appleLogin(login: AppleLoginRequestDTO)
    case kakaoLogin(login: KakaoLoginRequestDTO)
}

extension UserAPI: BaseAPI {
    
    var path: String {
        switch self {
        case .checkEmailValidation: return "v1/users/validation/email"
        case .join: return "v1/users/join"
        case .login: return "v2/users/login"
        case .appleLogin: return "v1/users/login/apple"
        case  .kakaoLogin: return "v1/users/login/kakao"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .checkEmailValidation, .join, .login, .appleLogin, .kakaoLogin: return .post
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
        case .kakaoLogin(let login):
            return .requestJSONEncodable(login)
        }
    }
    
}
