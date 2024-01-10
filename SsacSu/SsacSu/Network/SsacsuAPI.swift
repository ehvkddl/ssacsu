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
}

extension SsacsuAPI: TargetType {
    
    var baseURL: URL {
        URL(string: Configurations.baseURL)!
    }
    
    var path: String {
        switch self {
        case .checkEmailValidation: return "users/validation/email"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .checkEmailValidation: return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .checkEmailValidation(let email):
            return .requestJSONEncodable(email)
        }
    }
    
    var headers: [String : String]? {
        [
            "Content-Type": "application/json",
            "SesacKey": Configurations.SeSACKey
        ]
    }
    
}
