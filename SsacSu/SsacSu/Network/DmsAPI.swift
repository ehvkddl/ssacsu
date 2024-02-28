//
//  DmsAPI.swift
//  SsacSu
//
//  Created by do hee kim on 2024/02/28.
//

import Foundation

import Moya

enum DmsAPI {
}

extension DmsAPI: BaseAPI {
    
    var baseURL: URL {
        URL(string: Configurations.baseURL)!
    }
    
    var path: String {
        switch self {
        }
    }
    
    var method: Moya.Method {
        switch self {
        }
    }
    
    var task: Moya.Task {
        switch self {
        }
    }
    
    var headers: [String : String]? {
        switch self {
        }
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
    
}
