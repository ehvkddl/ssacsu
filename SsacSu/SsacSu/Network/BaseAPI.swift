//
//  BaseAPI.swift
//  SsacSu
//
//  Created by do hee kim on 2024/01/23.
//

import Foundation
import Moya

protocol BaseAPI: TargetType { }

extension BaseAPI {
    
    var baseURL: URL {
        URL(string: Configurations.baseURL)!
    }
    
    var headers: [String : String]? {
        [
            "Content-Type": "application/json",
            "SesacKey": Configurations.SeSACKey
        ]
    }
    
}
