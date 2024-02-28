//
//  DmsAPI.swift
//  SsacSu
//
//  Created by do hee kim on 2024/02/28.
//

import Foundation

import Moya

enum DmsAPI {
    case fetchDMsRoom(workspaceID: Int)
}

extension DmsAPI: BaseAPI {
    
    var baseURL: URL {
        URL(string: Configurations.baseURL)!
    }
    
    var path: String {
        switch self {
        case .fetchDMsRoom(let id): return "v1/workspaces/\(id)/dms"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchDMsRoom: return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .fetchDMsRoom: return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .fetchDMsRoom:
            [
                "Content-Type": "application/json",
                "SesacKey": Configurations.SeSACKey
            ]
        }
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
    
}
